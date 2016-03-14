//
//  XPCommonRefreshFooter.m
//  XPApp
//
//  Created by jy on 16/1/13.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPCommonRefreshFooter.h"

#define BOUNDWidth [UIScreen mainScreen].bounds.size.width

@interface XPCommonRefreshFooter ()
@property (nonatomic, nonatomic) UIImageView *loadingView;
@end

@implementation XPCommonRefreshFooter

- (UIImageView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [[UIImageView alloc] init];
        _loadingView.frame = CGRectMake(BOUNDWidth/2 - 100, 5, 100, 30);
        [self addSubview:_loadingView];
        if(!_loadingView.animationImages)
        {
            _loadingView.animationImages = [NSArray arrayWithObjects:
                                            [UIImage imageNamed:@"jiazai_1.png"],
                                            [UIImage imageNamed:@"jiazai_2.png"],
                                            [UIImage imageNamed:@"jiazai_3.png"],
                                            [UIImage imageNamed:@"jiazai_4.png"],
                                            [UIImage imageNamed:@"jiazai_5.png"],
                                            [UIImage imageNamed:@"jiazai_6.png"],
                                            [UIImage imageNamed:@"jiazai_7.png"],
                                            [UIImage imageNamed:@"jiazai_8.png"],
                                            [UIImage imageNamed:@"jiazai_9.png"],
                                            [UIImage imageNamed:@"jiazai_10.png"],
                                            [UIImage imageNamed:@"jiazai_11.png"],
                                            nil];
            _loadingView.animationDuration = 0.9;
            _loadingView.animationRepeatCount = 0;
        }
    }
    return _loadingView;
}

- (void)placeSubviews
{
    [super placeSubviews];
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    // 根据状态做事情
    self.stateLabel.text = @"";
    if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing) {
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                self.loadingView.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.loadingView.alpha = 1.0;
                [self.loadingView stopAnimating];
            }];
        }else{
            self.stateLabel.text = @"上拉加载更多";
            [self.loadingView stopAnimating];
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            }];
        }
    } else if (state == MJRefreshStatePulling) {
        self.stateLabel.text = @"松开加载更多";
        [self.loadingView stopAnimating];
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
        }];
    } else if (state == MJRefreshStateRefreshing) {
        self.stateLabel.text = @"正在加载";
        [self.loadingView startAnimating];
    }
    else if (state == MJRefreshStateNoMoreData) {
        self.stateLabel.text = @"没有更多";
        [self.loadingView stopAnimating];
    }
}

@end
