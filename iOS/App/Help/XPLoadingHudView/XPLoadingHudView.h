//
//  XPLoadingHudView.h
//  XPApp
//
//  Created by jy on 16/1/15.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPLoadingHudView : UIView

+ (XPLoadingHudView*)sharedView;

- (void)showHud;
- (void)dismissHud;

@end
