//
//  XPBaseViewController.m
//  Huaban
//
//  Created by huangxinping on 4/21/15.
//  Copyright (c) 2015 iiseeuu.com. All rights reserved.
//

#import "XPAutoNIBColor.h"
#import "XPBaseViewController.h"

#import <JZNavigationExtension/UINavigationController+JZExtension.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <XPToast/XPToast.h>

@interface XPBaseViewController ()

@end

@implementation XPBaseViewController

#pragma mark - Lifecycle

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    //    self.navigationController.fullScreenInteractivePopGestureRecognizer = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.viewModel.active = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hideLoader];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.viewModel.active = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Layout

#pragma mark - Public Interface
- (UIViewController *)instantiateInitialViewControllerWithStoryboardName:(NSString *)storyboardName
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    UIViewController *viewController = [storyboard instantiateInitialViewController];
    return viewController;
}

- (UIViewController *)instantiateViewControllerWithStoryboardName:(NSString *)storyboardName identifier:(NSString *)identifier
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:identifier];
    return viewController;
}

- (void)pushViewController:(UIViewController *)viewController
{
    NSAssert(self.navigationController != nil, @"navigationController is nil!");
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)pop
{
    NSAssert(self.navigationController != nil, @"navigationController is nil!");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popToRoot
{
    NSAssert(self.navigationController != nil, @"navigationController is nil!");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSArray *)popToViewController:(UIViewController *)viewController
{
    NSAssert(self.navigationController != nil, @"navigationController is nil!");
    return [self.navigationController popToViewController:viewController animated:YES];
}

#pragma mark - Delegate

#pragma mark - Internal Helpers
@end

@implementation XPBaseViewController (Login)

#pragma mark - User Interfaction
- (UIViewController *)presentLogin
{
    //TODO: Login登录可在任意子类使用
    UIViewController *loginNavigation = [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    [self presentViewController:loginNavigation animated:NO completion:^{
    }];
    return loginNavigation;
}

@end

@implementation XPBaseViewController (Loader)

- (void)showLoader
{
    [self showLoaderWithText:@"加载中..."];
}

- (void)showModalLoader
{
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeGradient];
}

- (void)showLoaderWithText:(NSString *)text
{
    [SVProgressHUD showWithStatus:text];
}

- (void)hideLoader
{
    [SVProgressHUD dismiss];
}

- (void)cleverLoader:(NSNumber *)state
{
    if([state boolValue]) {
        [self showLoader];
        [self.view endEditing:YES];
    } else {
        [self hideLoader];
    }
}

@end

@implementation XPBaseViewController (Toast)

- (void)showToast:(NSString *)text
{
    if([text isEqualToString:@"您的账号已在别处登录，当前登录已经退出"]) {
        [self presentLogin];
    }
    
    [XPToast showWithText:text];
}

@end

@implementation XPBaseViewController (RACSignal)

- (RACSignal *)rac_Appear
{
    return [[RACSignal
             merge:@[
                     [[self rac_signalForSelector:@selector(viewDidAppear:)] mapReplace:@YES],
                     [[self rac_signalForSelector:@selector(viewWillDisappear:)] mapReplace:@NO]
                     ]]
            setNameWithFormat:@"%@ rac_Appear", self];
}

@end
