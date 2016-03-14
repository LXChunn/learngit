//
//  XPCommonRefreshHeader.m
//  XPApp
//
//  Created by jy on 16/1/13.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPCommonRefreshHeader.h"
#import "MJRefreshStateHeader.h"
#define BOUNDWidth [UIScreen mainScreen].bounds.size.width

@interface XPCommonRefreshHeader ()

@property (nonatomic, nonatomic) UIImageView *arrowView;
@property (nonatomic, nonatomic) UIImageView *loadingView;
@property (nonatomic,strong) UILabel *stateLabel;
@property (nonatomic,strong) NSMutableArray * images;;
@end

@implementation XPCommonRefreshHeader

#pragma mark - 懒加载子控件
- (UIImageView *)arrowView
{
    if (!_arrowView) {
        UIImage *image = [UIImage imageNamed:@"xiala_1"];
        _arrowView = [[UIImageView alloc] initWithImage:image];
        _arrowView.frame = CGRectMake(BOUNDWidth/2 - 80, 10, 100, 30);
        [self addSubview:_arrowView];
    }
    return _arrowView;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [UILabel label];
        _stateLabel.frame = CGRectMake(BOUNDWidth/2 - 20, 15, 80, 20);
        _stateLabel.text = @"下拉刷新";
        [self addSubview:_stateLabel];
    }
    return _stateLabel;
}

- (UIImageView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [[UIImageView alloc] init];
        _loadingView.frame = CGRectMake(BOUNDWidth/2 - 80, 10, 100, 30);
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

- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    if (!_images) {
        _images = [NSMutableArray array];
        for (int i = 1; i < 26; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"xiala_%d",i]];
            [_images addObject:image];
        }
    }
    if (self.state != MJRefreshStateIdle || _images.count == 0) return;
    // 停止动画
    [self.loadingView stopAnimating];
    _arrowView.hidden = NO;
    // 设置当前需要显示的图片
    NSUInteger index =  _images.count * pullingPercent;
    if (index >= _images.count) index = _images.count - 1;
    self.arrowView.image = _images[index];
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing) {
            _stateLabel.text = @"";
            self.arrowView.transform = CGAffineTransformIdentity;
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                self.loadingView.alpha = 0.0;
            } completion:^(BOOL finished) {
                // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                if (self.state != MJRefreshStateIdle) return;
                _stateLabel.text = @"下拉刷新";
                self.loadingView.alpha = 1.0;
                [self.loadingView stopAnimating];
                self.arrowView.hidden = NO;
            }];
        } else {
            _stateLabel.text = @"下拉刷新";
            [self.loadingView stopAnimating];
            self.arrowView.hidden = NO;
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.arrowView.transform = CGAffineTransformIdentity;
            }];
        }
    }else if (state == MJRefreshStatePulling) {
        self.stateLabel.text = @"松开刷新";
        [self.loadingView stopAnimating];
        self.arrowView.hidden = NO;
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
        }];
    } else if (state == MJRefreshStateRefreshing) {
        self.stateLabel.text = @"正在加载";
        self.loadingView.alpha = 1.0; // 防止refreshing -> idle的动画完毕动作没有被执行
        [self.loadingView startAnimating];
        self.arrowView.hidden = YES;
    }
}

@end
