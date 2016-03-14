//
//  XPShareAlertController.h
//  XPApp
//
//  Created by jy on 16/1/12.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XPShareAlertController;
@protocol XPShareControllerDelegate <NSObject>
@optional
- (void)shareController:(XPShareAlertController *)shareController didSelectRow:(NSInteger)row;

@end

@interface XPShareAlertController : UIWindow

@property (nonatomic, weak) id<XPShareControllerDelegate> delegate;

- (instancetype)initWithActivity:(NSArray *)activitys;

- (void)show;
@end
