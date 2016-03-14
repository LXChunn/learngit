//
//  XPAlertController.h
//  XPApp
//
//  Created by xinpinghuang on 12/25/15.
//  Copyright © 2015 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XPAlertController;
@protocol XPAlertControllerDelegate <NSObject>

@optional
- (void)alertControllerDidCanceled:(XPAlertController *)alertController;

- (void)alertController:(XPAlertController *)alertController didSelectRow:(NSInteger)row;

@end

@interface XPAlertController : UIWindow

@property (nonatomic, weak) id<XPAlertControllerDelegate> delegate;

- (instancetype)initWithActivity:(NSArray *)activitys;

- (void)show;

@end
