//
//  FeedVC.m
//  pet2share
//
//  Created by Tony Kieu on 7/12/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "FeedVC.h"
#import "Graphics.h"
#import "AppColor.h"
#import "FeedCollectionVC.h"
#import "FeedDetailVC.h"
#import "Post.h"
#import "NewPostVC.h"

@interface FeedVC () <BaseNavigationProtocol, FeedCollectionDelegate, NewPostDelegate>


@end

@implementation FeedVC

#pragma mark -
#pragma mark Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.baseNavProtocol = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Setup navigation title
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName: [AppColor navigationBarTextColor],
       NSFontAttributeName:[UIFont fontWithName:kLogoTypeface size:20.0f]}];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSeguePostDetail] && [sender isKindOfClass:[Post class]])
    {
        FeedDetailVC *detailVC = (FeedDetailVC *)segue.destinationViewController;
        detailVC.post = (Post *)sender;
    }
    else if ([segue.identifier isEqualToString:kSegueNewPost])
    {
        NewPostVC *newPostVC = (NewPostVC *)segue.destinationViewController;
        newPostVC.transitioningDelegate = self.transitionManager;
        newPostVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:kSegueFeedCollection])
    {
        [(FeedCollectionVC *)segue.destinationViewController setCollectionDelegate:self];
    }
}

- (void)dealloc
{
    TRACE_HERE;
}

#pragma mark -
#pragma mark Delegates

- (UIButton *)setupRightBarButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, kBarButtonWidth, kBarButtonHeight);
    [button setImage:[Graphics tintImage:[UIImage imageNamed:@"icon-compose"]
                               withColor:[AppColorScheme white]] forState:UIControlStateNormal];
    return button;
}

- (void)handleRightButtonEvent:(id)sender
{
    [self performSegueWithIdentifier:kSegueNewPost sender:self];
}


- (void)didSelectItem:(id)item
{
    [self performSegueWithIdentifier:kSeguePostDetail sender:item];
}

- (void)didPost
{
    TRACE_HERE;
}

@end