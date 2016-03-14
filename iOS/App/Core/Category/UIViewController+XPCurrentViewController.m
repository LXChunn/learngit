//
//  UIViewController+XPCurrentViewController.m
//  XPApp
//
//  Created by jy on 16/1/20.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "UIViewController+XPCurrentViewController.h"
#import "XPBaseNavigationViewController.h"
#import "XPBaseViewController.h"
#import "XPBaseTabBarViewController.h"
#import "XPHomeViewController.h"

@implementation UIViewController (XPCurrentViewController)

+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIViewController * vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([vc isKindOfClass:[XPBaseTabBarViewController class]]) {
        XPBaseNavigationViewController * navVC = [(XPBaseTabBarViewController *)vc selectedViewController];
        result = navVC.visibleViewController;
        return result;
    }
    return result;
}

+ (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

@end
