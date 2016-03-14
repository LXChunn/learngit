//
//  UIViewController+XPCurrentViewController.h
//  XPApp
//
//  Created by jy on 16/1/20.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (XPCurrentViewController)

+ (UIViewController *)getCurrentVC;

+ (UIViewController *)getPresentedViewController;

@end
