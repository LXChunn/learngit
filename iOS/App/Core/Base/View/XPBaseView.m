//
//  XPBaseView.m
//  Huaban
//
//  Created by huangxinping on 4/21/15.
//  Copyright (c) 2015 iiseeuu.com. All rights reserved.
//

#import "XPBaseView.h"

@interface XPBaseView ()

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic) CGFloat backgroundMargin;

@end

@implementation XPBaseView

- (void)setBackgroundImage:(UIImage *)image;
{
    NSLog(@"DEMO: setBackgroundImage");
    
    self.backgroundView.image = image;
}

- (void)setBackgroundMargin:(CGFloat)backgroundMargin;
{
    _backgroundMargin = backgroundMargin;
    [self setNeedsLayout];
}

- (UIImageView *)backgroundView;
{
    if(_backgroundView == nil) {
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        [self insertSubview:backgroundView atIndex:0];
        self.backgroundView = backgroundView;
    }
    
    return _backgroundView;
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)layoutSubviews;
{
    //    XPLogInfo(@"XPBaseView.layoutSubviews");    [super layoutSubviews];
    
    UIEdgeInsets backgroundEdgeInsets = UIEdgeInsetsMake(self.backgroundMargin, self.backgroundMargin, self.backgroundMargin, self.backgroundMargin);
    self.backgroundView.frame = UIEdgeInsetsInsetRect(self.bounds, backgroundEdgeInsets);
}

- (void)bindViewModel:(XPBaseViewModel *)viewModel
{
    XPLogError(@"Opps，you must implement sub class.");
}

@end
