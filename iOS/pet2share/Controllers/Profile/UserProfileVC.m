//
//  UserProfileVC.m
//  pet2share
//
//  Created by Tony Kieu on 10/7/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "UserProfileVC.h"
#import "AppColor.h"
#import "PetCollectionCell.h"
#import "EmptyPetCollectionCell.h"
#import "Pet2ShareService.h"
#import "Pet2ShareUser.h"
#import "PetProfileVC.h"
#import "AddEditPetProfileVC.h"

static NSString * const kCellIdentifier         = @"petcollectioncell";
static NSString * const kCellNibName            = @"PetCollectionCell";
static NSString * const kEmptyCellIdentifier    = @"emptypetcollectioncell";
static NSString * const kEmptyCellNibName       = @"EmptyPetCollectionCell";
static CGFloat kCellSpacing                     = 5.0f;

@interface UserProfileVC () <Pet2ShareServiceCallback, EditProfileDelegate>
{
    CachePolicy _cachePolicy;
}

@end

@implementation UserProfileVC

#pragma mark - Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.cellReuseIdentifier = kCellIdentifier;
        self.customNibName = kCellNibName;
        _cachePolicy = CacheDefault;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set title text attribute (Lobster Typeface)
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName: [AppColor navigationBarTextColor],
       NSFontAttributeName:[UIFont fontWithName:kLogoTypeface size:20.0f]}];
    
    // Register extra cells
    [self.collectionView registerNib:[UINib nibWithNibName:kEmptyCellNibName bundle:nil]
          forCellWithReuseIdentifier:kEmptyCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestUserData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:kSeguePetProfile])
    {
        PetProfileVC *viewController = (PetProfileVC *)segue.destinationViewController;
        viewController.pet = (Pet *)sender;
    }
    else if ([segue.identifier isEqualToString:kSegueAddEditPetProfile])
    {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        AddEditPetProfileVC *addEditProfileVC = (AddEditPetProfileVC *)navController.topViewController;
        if (addEditProfileVC)
        {
            addEditProfileVC.petProfileMode = AddPetProfile;
            addEditProfileVC.pet = [Pet new];
            addEditProfileVC.delegate = self;
        }
        navController.transitioningDelegate = self.transitionManager;
    }
}

- (void)dealloc
{
    TRACE_HERE;
}

#pragma mark - Private & Protected Instance Methods

- (NSString *)getProfileImageUrl
{
    return [Pet2ShareUser current].person.profilePictureUrl;
}

- (NSString *)getProfileCoverImageUrl
{
    return [Pet2ShareUser current].person.coverPictureUrl;
}

-  (NSString *)getProfileName
{
    NSString *name = [NSString stringWithFormat:@"%@ %@",
                      [Pet2ShareUser current].person.firstName, [Pet2ShareUser current].person.lastName];
    return name;
}

- (NSString *)getEditSegueIdentifier
{
    return kSegueEditProfile;
}

- (UIImage *)getProfileSessionAvatarImage
{
    return [Pet2ShareUser current].getUserSessionAvatarImage;
}

- (void)setupLayout
{
    CollectionViewLayout *layout = (CollectionViewLayout *)self.collectionViewLayout;
    
    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]])
    {
        layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, [ProfileHeaderCell height]);
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.view.frame.size.width, [ProfileHeaderCell height]-10.0f);
        [layout setupLayout:TwoColumns cellHeight:[PetCollectionCell height:kCellSpacing] spacing:kCellSpacing];
        layout.parallaxHeaderAlwaysOnTop = NO;
        layout.disableStickyHeaders = YES;
    }
}

#pragma mark - Events

- (void)addButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:kSegueAddEditPetProfile sender:self];
}

#pragma mark - Web service

- (void)requestUserData
{
    [self.items removeAllObjects];
    [self.items addObjectsFromArray:[Pet2ShareUser current].pets];
    [self.collectionView reloadData];
    Pet2ShareService *service = [Pet2ShareService new];
    [service getUserProfile:self userId:[Pet2ShareUser current].identifier cachePolicy:_cachePolicy];
}

- (void)onReceiveSuccess:(NSArray *)objects
{
    if (objects.count == 1)
    {
        User *user = objects[0];
        // fTRACE("User: %@", user);
        [[Pet2ShareUser current] updateFromUser:user];
        [self.collectionView reloadData];
    }
    _cachePolicy = CacheDefault;
}

- (void)onReceiveError:(ErrorMessage *)errorMessage
{
    fTRACE("Error: %@", errorMessage.message);
    [Graphics alert:NSLocalizedString(@"Error", @"") message:errorMessage.message type:ErrorAlert];
}

#pragma mark - <EditProfileDelegate>

- (void)didUpdateProfile
{
    _cachePolicy = ForceRefresh;
}

#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.items count] + 1;  // With empty cell
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    @try
    {
        if (indexPath.row == self.items.count)  // This is the bottom of the list
        {
            cell = (EmptyPetCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kEmptyCellIdentifier
                                                                                  forIndexPath:indexPath];
            [((EmptyPetCollectionCell *)cell).addPetBtn addTarget:self action:@selector(addButtonTapped:)
                                                 forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            cell = (PetCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:self.cellReuseIdentifier
                                                                                  forIndexPath:indexPath];
            Pet *pet = [self.items objectAtIndex:indexPath.row];
            [(PetCollectionCell *)cell setupView:pet];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s: Exception: %@", __func__, exception.description);
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    fTRACE(@"Tile Selected Index: %ld", (long)indexPath.row);
    
    @try
    {
        if (indexPath.row == self.items.count)
        {
            [self addButtonTapped:self];
        }
        else
        {
            Pet *pet = [self.items objectAtIndex:indexPath.row];
            [self performSegueWithIdentifier:kSeguePetProfile sender:pet];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s: Exception: %@", __func__, exception.description);
    }
}

@end