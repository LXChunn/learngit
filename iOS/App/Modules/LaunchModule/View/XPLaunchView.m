//
//  XPLaunchView.m
//  XPApp
//
//  Created by huangxinping on 15/8/14.
//  Copyright (c) 2015年 iiseeuu.com. All rights reserved.
//

#import "XPLaunchView.h"

#define MCANIMATE_SHORTHAND
#import <POP+MCAnimate/POP+MCAnimate.h>

#import <pop/POP.h>

@interface XPLaunchView ()

@end

@implementation XPLaunchView

- (void)awakeFromNib
{
}

- (void)setAnimationWithPOP
{
    { // alpha
        POPBasicAnimation *animation = [POPBasicAnimation linearAnimation];
        animation.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
        animation.toValue = @(0.01);
        animation.duration = 0.5;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self pop_addAnimation:animation forKey:@"Alpha"];
        });
    }
    { // scale
        POPBasicAnimation *animation = [POPBasicAnimation linearAnimation];
        animation.property = [POPAnimatableProperty propertyWithName:kPOPLayerScaleXY];
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(30, 30)];
        animation.duration = 0.5;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self pop_addAnimation:animation forKey:@"ZoomOutY"];
        });
    }
}

- (void)setAnimationWithPOPMCAnimation
{
    { // not use comepletion's block
        //        self.duration = 1;
        //        self.delay = 2.0;
        //        self.linear.alpha = 0.01;
        //        self.linear.scaleXY = ccp(10.0, 10.0);
    }
    { // yse comepletion block
        self.duration = 1;
        self.beginTime = CACurrentMediaTime() + 2.0;
        @weakify(self);
        [NSObject animate:^{
            @strongify(self);
            self.linear.alpha = 0.01;
            self.linear.scaleXY = ccp(4.0, 4.0);
        }
               completion:^(BOOL finished) {
                   [self removeFromSuperview];
               }];
        
        // you cant stop any one.
        // [self.stop alpha];
        // [self.stop scaleXY];
    }
}

#pragma mark - Public Interface
- (void)startAnimation
{
    [self setAnimationWithPOPMCAnimation];
}

@end
