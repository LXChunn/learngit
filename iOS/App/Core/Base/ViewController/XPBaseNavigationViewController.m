//
//  XPBaseNavigationViewController.m
//  Huaban
//
//  Created by huangxinping on 4/21/15.
//  Copyright (c) 2015 iiseeuu.com. All rights reserved.
//

#import "XPBaseNavigationBar.h"
#import "XPBaseNavigationViewController.h"

#import <JZNavigationExtension/UINavigationController+JZExtension.h>

@interface XPBaseNavigationViewController ()

@end

@implementation XPBaseNavigationViewController

- (id)init
{
    self = [super initWithNavigationBarClass:[XPBaseNavigationBar class] toolbarClass:nil];
    if(self) {
        // Custom initialization here, if needed.
        
        // To override the opacity of CRNavigationBar's barTintColor, set this value to YES.
        ((XPBaseNavigationBar *)self.navigationBar).overrideOpacity = NO;
    }
    
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithNavigationBarClass:[XPBaseNavigationBar class] toolbarClass:nil];
    if(self) {
        self.viewControllers = @[rootViewController];
        
        // To override the opacity of XPBaseNavigationBar's barTintColor, set this value to YES.
        ((XPBaseNavigationBar *)self.navigationBar).overrideOpacity = NO;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Remove left UIBarButtonItem's title
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
