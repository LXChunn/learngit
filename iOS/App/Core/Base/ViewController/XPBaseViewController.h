//
//  XPBaseViewController.h
//  Huaban
//
//  Created by huangxinping on 4/21/15.
//  Copyright (c) 2015 iiseeuu.com. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <UIKit/UIKit.h>

#import "XPAuthorModel.h"
#import "XPBaseModel.h"
#import "XPBaseStorage.h"
#import "XPBaseViewModel.h"
#import "XPNoDataView.h"

@interface XPBaseViewController : UIViewController

/**
 *  模型
 */
@property (nonatomic, strong, setter = setupWithModel :, getter = model) XPBaseModel *model;

/**
 *  ViewModel
 */
@property (nonatomic, strong) XPBaseViewModel *viewModel;

/**
 *  初始化Entry ViewController
 *
 *  @param storyboardName 名称
 *
 *  @return 视图控制器
 */
- (UIViewController *)instantiateInitialViewControllerWithStoryboardName:(NSString *)storyboardName;

/**
 *  初始化ViewController根据标示符
 *
 *  @param storyboardName 名称
 *  @param identifier     标示符
 *
 *  @return 视图控制器
 */
- (UIViewController *)instantiateViewControllerWithStoryboardName:(NSString *)storyboardName identifier:(NSString *)identifier;

/**
 *  导航视图控制器push
 *
 *  @param viewController 目标视图控制器
 */
- (void)pushViewController:(UIViewController *)viewController;

/**
 *  导航视图控制器pop
 */
- (void)pop;

/**
 *  导航视图控制器pop到root
 */
- (void)popToRoot;

/**
 *  导航视图控制器pop到指定viewController
 *
 *  @param viewController 目标视图控制器
 *
 *  @return 被pop的视图控制器组
 */
- (NSArray *)popToViewController:(UIViewController *)viewController;

@end

@interface XPBaseViewController (Login)

/**
 *  是否已登录
 */
- (BOOL)isLogin;

/**
 *  是否已经绑定房屋信息
 */
- (BOOL)isBindHouse;

/**
 *  弹出Login视图控制器
 */
- (UIViewController *)presentLogin;

/**
 *  弹出房屋绑定视图控制器
 */
- (UIViewController *)presentBindHouse;

@end

@interface XPBaseViewController (Loader)

/**
 *  显示载入器（特定的时候才会显示）
 */
- (void)showLoader;

/**
 *  刚进入VC时显示
 */
- (void)showFirstHud;

/**
 *  隐藏
 */
- (void)hideFirstHud;

/**
 *  显示载入器
 *
 *  @param text 显示的文字
 */
- (void)showLoaderWithText:(NSString *)text;

/**
 *  显示模态载入器
 */
- (void)showModalLoader;

/**
 *  移除载入器
 */
- (void)hideLoader;

/**
 *  聪慧的载入器
 */
- (void)cleverLoader:(NSNumber *)state;

@end

@interface XPBaseViewController (Toast)

/**
 *  显示Toast！0.5秒自动消失
 */
- (void)showToast:(NSString *)text;

@end

@interface XPBaseViewController (RACSignal)

/**
 *  viewDidAppear被触发时返回@YES信号，viewWillDisappear被触发时返回@NO信号
 *
 *  @return 信号
 */
- (RACSignal *)rac_Appear;
@end

@interface XPBaseViewController (OtherUserInfo)

/**
 *  进入他人的个人中心
 *
 *  @param model 数据
 */
- (void)goOtherUserInfoCenterWithModel:(XPAuthorModel *)model;

@end

typedef void (^ClickReloadBlock)();
@interface XPBaseViewController (NoDataAndError)

- (void)showNoDataViewWithType:(NoDataType)type;

- (void)showNonetworkViewWithBlock:(ClickReloadBlock)block;

- (void)removeNoNetworkView;

@end