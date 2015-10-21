//
//  ProfileSelectionVC.m
//  pet2share
//
//  Created by Tony Kieu on 10/21/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "ProfileSelectionVC.h"
#import "Graphics.h"
#import "ProfileSelectionTableCell.h"
#import "Pet2ShareUser.h"

@interface ProfileSelectionVC () <BaseNavigationProtocol, UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _selectedIndex;
    BOOL _isDirty;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *cellData;
@property (strong, nonatomic) Pet *selectedPet;

@end

@implementation ProfileSelectionVC

static NSString * const kCellReuseIdentifier    = @"profileselectiontablecell";
static NSString * const kCellNibName            = @"ProfileSelectionTableCell";
static NSString * const kCellTextKey            = @"textkey";
static NSString * const kCellImageUrlKey        = @"imageurlkey";
static NSString * const kCellIsMaster           = @"ismasterkey";

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.baseNavProtocol = self;
        _cellData = [NSMutableArray array];
        _selectedIndex = 0;
        _selectedPet = [Pet2ShareUser current].selectedPet;
        _isDirty = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:kCellNibName bundle:nil] forCellReuseIdentifier:kCellReuseIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    Pet2ShareUser *currUser = [Pet2ShareUser current];
    NSString *name = [NSString stringWithFormat:@"%@ %@", currUser.person.firstName, currUser.person.lastName];
    [self.cellData addObject:@{kCellTextKey: name, kCellImageUrlKey: currUser.person.profilePictureUrl, kCellIsMaster: @(YES)}];
    
    [currUser.pets enumerateObjectsUsingBlock:^(Pet *pet, NSUInteger idx, BOOL *stop) {
        
        if (pet.identifier == self.selectedPet.identifier)
        {
            _selectedPet = pet;
            _selectedIndex = idx+1;
        }
        [self.cellData addObject:@{kCellTextKey: pet.name,
                                   kCellImageUrlKey: pet.profilePictureUrl,
                                   kCellIsMaster: @(NO)}];
    }];
}

#pragma mark -
#pragma mark <BaseNavigationProtocol>

- (UIButton *)setupLeftBarButton
{
    return [Graphics createBarButtonWithTitle:NSLocalizedString(@"CANCEL", @"")];
}

- (UIButton *)setupRightBarButton
{
    return [Graphics createBarButtonWithTitle:NSLocalizedString(@"DONE", @"")];
}

- (void)handleLeftButtonEvent:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleRightButtonEvent:(id)sender
{
    if (_isDirty)
    {
        [Graphics promptAlert:NSLocalizedString(@"Save Settings", @"")
                      message:NSLocalizedString(@"Do you want to set a new default profile?", @"")
                         type:NormalAlert
                           ok:^(SIAlertView *alert) {
                               [Pet2ShareUser current].selectedPet = self.selectedPet;
                               [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                           } cancel:^(SIAlertView *alert) {
                               return;
                           }];
    }
}

#pragma mark -
#pragma mark <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cellData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try
    {
        NSDictionary *data = self.cellData[indexPath.row];
        ProfileSelectionTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
        if (!cell) cell = [[ProfileSelectionTableCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                           reuseIdentifier:kCellReuseIdentifier];
        [(ProfileSelectionTableCell *)cell loadDataWithImageUrl:data[kCellImageUrlKey]
                                           placeHolderImageName:@"img-avatar"
                                                       nameText:data[kCellTextKey]
                                                       isMaster:[data[kCellIsMaster] boolValue]];
        
        if (_selectedIndex == indexPath.row) cell.checkMark.checked = YES;
        else cell.checkMark.checked = NO;
        
        if (![cell.checkMark respondsToSelector:@selector(checkMarkTouched:)])
        {
            [cell.checkMark setTag:indexPath.row];
            [cell.checkMark addTarget:self action:@selector(checkMarkTouched:)
                     forControlEvents:UIControlEventTouchUpInside];
        }
        
        return cell;
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s : Exception: %@", __func__, [exception description]);
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:@"cell"];
        return cell;
    }
}

- (void)checkMarkTouched:(id)sender
{
    if ([sender isKindOfClass:[CheckMark class]])
    {
        CheckMark *checkMark = (CheckMark *)sender;
        _selectedIndex = checkMark.tag;
        _isDirty = YES;
        
        if (_selectedIndex == 0)
            self.selectedPet = nil;
        else
            self.selectedPet = [Pet2ShareUser current].pets[checkMark.tag-1];
        
        fTRACE(@"Selected Pet: %@", self.selectedPet);

        [self.tableView reloadData];
    }
    else
    {
        fTRACE("Unrecognized Sender: %@", [sender localizedDescription]);
    }
}

#pragma mark -
#pragma mark <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ProfileSelectionTableCell height];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        [cell setLayoutMargins:UIEdgeInsetsZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileSelectionTableCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self checkMarkTouched:cell.checkMark];
}

@end
