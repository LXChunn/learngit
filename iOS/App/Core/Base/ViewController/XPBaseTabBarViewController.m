//
//  XPBaseTabBarViewController.m
//  Huaban
//
//  Created by huangxinping on 4/21/15.
//  Copyright (c) 2015 iiseeuu.com. All rights reserved.
//

#import "XPAutoNIBColor.h"
#import "XPBaseNavigationViewController.h"
#import "XPBaseTabBarViewController.h"
#import "XPBaseViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <XPKit/XPKit.h>

@interface XPBaseTabBarViewController ()

@end

@implementation XPBaseTabBarViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.tabBar.barTintColor = [XPAutoNIBColor colorWithName:@"c3"];
//    self.tabBar.tintColor = [XPAutoNIBColor colorWithName:@"c2"];
    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    
    NSMutableArray *tabbarViewControllers = [NSMutableArray arrayWithArray:[self viewControllers]];
    { // 主页
        UIViewController *viewController = tabbarViewControllers[0];
        UIImage *normal = [[UIImage imageNamed:@"tab_home_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selected = [[UIImage imageNamed:@"tab_home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"主页" image:normal selectedImage:selected];
    }
    { // 便民
        UIViewController *viewController = [self viewControllerWithTabTitle:@"便民" image:@"tab_convenience_normal" selectedImage:@"tab_convenience_selected" storyboardName:@"Forum"];
        [tabbarViewControllers addObject:viewController];
    }
    
    { // 邻里
        UIViewController *viewController = [self viewControllerWithTabTitle:@"邻里" image:@"tab_neighborhood_normal" selectedImage:@"tab_neighborhood_selected" storyboardName:@"Neighborhood"];
        [tabbarViewControllers addObject:viewController];
    }
    { // 我
        UIViewController *viewController = [self viewControllerWithTabTitle:@"我" image:@"tab_me_normal" selectedImage:@"tab_me_selected" storyboardName:@"Me"];
        [tabbarViewControllers addObject:viewController];
    }
    
    [self setViewControllers:tabbarViewControllers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Delegate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

#pragma mark - Private Methods
- (UIViewController *)viewControllerWithTabTitle:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage storyboardName:(NSString *)storyboardName
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    UIViewController *viewController = [storyboard instantiateInitialViewController];
    viewController.title = title;
    UIImage *normal = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selected = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:normal selectedImage:selected];
    return viewController;
}

#pragma mark - Getters & Setters

@end
