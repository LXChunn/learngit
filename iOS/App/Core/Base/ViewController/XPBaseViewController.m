//
//  XPBaseViewController.m
//  Huaban
//
//  Created by huangxinping on 4/21/15.
//  Copyright (c) 2015 iiseeuu.com. All rights reserved.
//

#import "XPAutoNIBColor.h"
#import "XPBaseViewController.h"

#import "UIView+XPKit.h"
#import "XPLoginModel.h"
#import "XPNoNetworkView.h"
#import "XPOtherDetailViewController.h"
#import "XPUser.h"
#import <JZNavigationExtension/UINavigationController+JZExtension.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <XPToast/XPToast.h>
#import "XPLoadingHudView.h"
#import "XPLoginStorage.h"

@interface XPBaseViewController ()
@property (nonatomic, strong) XPNoNetworkView *noNetworkView;
@property (nonatomic, strong) XPNoDataView *noDataView;

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
    [self hideFirstHud];
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
- (UIViewController *)presentBindHouse
{
    UIViewController *house = [[UIStoryboard storyboardWithName:@"Household" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    [self presentViewController:house animated:NO completion:^{
    }];
    return house;
}

- (UIViewController *)presentLogin
{
    //TODO: Login登录可在任意子类使用
    UIViewController *loginNavigation = [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    [self presentViewController:loginNavigation animated:NO completion:^{
    }];
    return loginNavigation;
}

- (BOOL)isBindHouse
{
    if(![XPLoginModel singleton].isBound) {
        return NO;
    }
    return YES;
}

- (BOOL)isLogin
{
    if([XPLoginStorage user].accessToken.length < 1) {
        return NO;
    }
    return YES;
}

@end

@implementation XPBaseViewController (Loader)

- (void)showLoader
{
    [[XPLoadingHudView sharedView] showHud];
}

- (void)hideLoader
{
    [[XPLoadingHudView sharedView] dismissHud];
}

- (void)showModalLoader
{
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeGradient];
}

- (void)showLoaderWithText:(NSString *)text
{
    [SVProgressHUD showWithStatus:text];
}

- (void)showFirstHud
{
    [SVProgressHUD showWithStatus:@""];
}

- (void)hideFirstHud
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
    if([text isEqualToString:@"授权已过期，请重新登录"]) {
        [XPLoginStorage clearCached];
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

@implementation XPBaseViewController (OtherUserInfo)

- (void)goOtherUserInfoCenterWithModel:(XPAuthorModel *)model
{
    if([model.userId integerValue] == [XPLoginModel singleton].userId.integerValue) {
        [self pushViewController:[self instantiateViewControllerWithStoryboardName:@"UserInfo" identifier:@"XPUserInfoCenterViewController"]];
    } else {
        XPOtherDetailViewController *otherViewController = (XPOtherDetailViewController *)[self instantiateViewControllerWithStoryboardName:@"OtherUser" identifier:@"XPOtherDetailViewController"];
        otherViewController.otherModel = model;
        [self pushViewController:otherViewController];
    }
}

@end

@implementation XPBaseViewController (NoDataAndError)

- (void)showNoDataViewWithType:(NoDataType)type;
{
    _noDataView = [[[NSBundle mainBundle] loadNibNamed:@"XPNoDataView" owner:nil options:nil] lastObject];
    _noDataView.frame = self.view.bounds;
    [_noDataView configureUIWithType:type];
    [self.view addSubview:_noDataView];
    [_noDataView bringToFront];
}

- (void)showNonetworkViewWithBlock:(ClickReloadBlock)block
{
    if(!_noNetworkView) {
        _noNetworkView = [[[NSBundle mainBundle] loadNibNamed:@"XPNoNetworkView" owner:nil options:nil] lastObject];
        _noNetworkView.frame = self.view.bounds;
        [self.view addSubview:_noNetworkView];
        [_noNetworkView bringToFront];
        [_noNetworkView whenClickTryButtonWith:^{
            block();
        }];
    }
}

- (void)removeNoNetworkView
{
    if(_noNetworkView) {
        [_noNetworkView removeFromSuperview];
    }
    if(_noDataView) {
        [_noDataView removeFromSuperview];
    }
}

@end