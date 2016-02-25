//
//  XPBaseShareActivity.h
//  XPApp
//
//  Created by xinpinghuang on 12/24/15.
//  Copyright © 2015 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>

//用来给XPShareActivityViewController用的。
typedef void (^xp_shareActivityClickBlock)();

@interface XPBaseShareActivity : UIView

@property (nonatomic, copy) xp_shareActivityClickBlock block;

- (NSString *)        activityTitle;
- (UIImage *)         activityImage;
- (UIViewController *)activityViewController;
- (void)              performActivity;

/**
 *  按钮是否可点击。默认YES
 *
 *  @return YES
 */
- (BOOL)buttonEnable;

@end
