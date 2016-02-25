//
//  XPShareActivityViewController.h
//  XPApp
//
//  Created by xinpinghuang on 12/24/15.
//  Copyright © 2015 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^XPShareActivityViewControllerCompletionHandler)(NSString *activityType, BOOL completed);
typedef void (^XPShareActivityViewControllerCompletionWithItemsHandler)(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError);

@interface XPShareActivityViewController : UIWindow

/**
 *  初始化ActivityViewController
 *  注意：actionActivities不可为空。
 *
 *  @param shareActivity    分享组件若要有。在第一行
 *  @param actionActivities 行为。必须有。在下面那行
 *
 *  @return
 */
- (instancetype)initWithASharedActivity:(NSArray *)shareActivity actionActivities:(NSArray *)actionActivities;

/**
 *  显示ActivityViewController
 */
- (void)show;

@end
