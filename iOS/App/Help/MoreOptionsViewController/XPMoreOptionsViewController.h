//
//  XPMoreOptionsViewController.h
//  XPApp
//
//  Created by jy on 15/12/28.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XPMoreOptionsViewController;
@protocol XPOptionsViewControllerDelegate <NSObject>

@optional
- (void)optionsViewController:(XPMoreOptionsViewController *)optionsViewController didSelectRow:(NSInteger)row;

@end

@interface XPMoreOptionsViewController : UIWindow

@property (nonatomic, weak) id<XPOptionsViewControllerDelegate>delegate;

- (instancetype)initWithMoreOptionsWithIcons:(NSArray *)icons titles:(NSArray *)titles;
- (void)        show;

@end
