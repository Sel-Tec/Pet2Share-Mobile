//
//  BaseNavigationVC.m
//  pet2share
//
//  Created by Tony Kieu on 7/10/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BaseNavigationVC.h"

@interface BaseNavigationVC () <ImageActionSheetDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) ImageActionSheet *actionSheet;

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation BaseNavigationVC

#pragma mark -
#pragma mark Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        _transitionManager = [TransitionManager new];
        _transitionZoom = [TransitionZoom new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    // Config left bar button
    if ([self.baseNavProtocol respondsToSelector:@selector(setupLeftBarButton)] && !self.leftBtn)
    {
        _leftBtn = [self.baseNavProtocol setupLeftBarButton];
        if (self.leftBtn)
        {
            [self.leftBtn addTarget:self action:@selector(handleLeftButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
        }
    }
    
    // Config right bar button
    if ([self.baseNavProtocol respondsToSelector:@selector(setupRightBarButton)] && !self.rightBtn)
    {
        _rightBtn = [self.baseNavProtocol setupRightBarButton];
        if (self.rightBtn)
        {
            [self.rightBtn addTarget:self action:@selector(handleRightButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
        }
    }
    
    self.navigationController.navigationBar.layer.cornerRadius=25;
}

- (void)dealloc
{
    TRACE_HERE;
    self.leftBtn = nil;
    self.rightBtn = nil;
}

#pragma mark -
#pragma mark Public Instance Methods

- (void)handleLeftButtonEvent:(id)sender
{
    // Implement at subclass
}

- (void)handleRightButtonEvent:(id)sender
{
    // Implement at subclass
}

- (void)handleActionButton:(NSInteger)index
{
    // Implement at subclass
}

- (void)setLeftBarButtonTitle:(NSString *)text
{
    [self.leftBtn setTitle:text forState:UIControlStateNormal];
}

- (void)setLeftBarButtonImage:(UIImage *)image
{
    [self.leftBtn setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)setRightBarButtonTitle:(NSString *)text
{
    [self.rightBtn setTitle:text forState:UIControlStateNormal];
}

- (void)setRightBarButtonImage:(UIImage *)image
{
    [self.rightBtn setImage:image forState:UIControlStateNormal];
}

- (void)setupActionSheet:(NSString *)title buttons:(NSArray *)buttons
{
    _actionSheet = [[ImageActionSheet alloc] initWithTitle:title
                                                  delegate:self
                                          availableButtons:buttons
                                         cancelButtonTitle:NSLocalizedString(@"Cancel", @"")];
    [self.actionSheet showInViewController:self];
}

#pragma mark -
#pragma mark <ImageActionSheetDelegate>

- (void)actionSheet:(ImageActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([self.baseNavProtocol respondsToSelector:@selector(handleActionButton:)])
        [self.baseNavProtocol handleActionButton:buttonIndex];
}

@end
