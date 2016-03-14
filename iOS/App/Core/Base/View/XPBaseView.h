//
//  XPBaseView.h
//  Huaban
//
//  Created by huangxinping on 4/21/15.
//  Copyright (c) 2015 iiseeuu.com. All rights reserved.
//

#import "XPBaseReactiveView.h"
#import "XPBaseViewModel.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <UIKit/UIKit.h>
#import <XPKit/XPKit.h>

@interface XPBaseView : UIView <XPBaseReactiveView, UIAppearanceContainer>

- (void)setBackgroundImage:(UIImage *)image UI_APPEARANCE_SELECTOR;
- (void)setBackgroundMargin:(CGFloat)backgroundMargin UI_APPEARANCE_SELECTOR;

@end
