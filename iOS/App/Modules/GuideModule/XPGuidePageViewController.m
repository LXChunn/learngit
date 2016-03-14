//
//  XPGuidePageViewController.m
//  XPApp
//
//  Created by jy on 16/1/25.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPGuidePageViewController.h"
#import "UIDevice+Resolutions.h"
#import "UIColor+XPKit.h"
#import "ReactiveCocoa.h"
#import "XPHomeViewController.h"
#import "UIView+Size.h"
#import "XPUser.h"

#define BOUNDWidth [UIScreen mainScreen].bounds.size.width
#define BOUNDHeight [UIScreen mainScreen].bounds.size.height

@interface XPGuidePageViewController ()<UIScrollViewDelegate>
{
}
@property (nonatomic,strong) UIPageControl * myPageControl;
@property (nonatomic,strong) UIView *oneView;
@property (nonatomic,strong) UIView *twoView;
@property (nonatomic,strong) UIView *threeView;
@property (nonatomic,strong) UIButton *pushButton;
@property (nonatomic,strong) UIImageView *oneTipImageView;
@property (nonatomic,strong) UIImageView *twoTipImageView;
@property (nonatomic,strong) UIImageView *threeTipImageView;
@property (nonatomic,strong) UIImageView *oneBottomImageView;
@property (nonatomic,strong) UIImageView *twoBottomImageView;
@property (nonatomic,strong) UIImageView *threeBottomImageView;



@end

@implementation XPGuidePageViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUI];
    [XPUser launched];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _oneTipImageView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _oneTipImageView.centerX = BOUNDWidth/2.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            _oneBottomImageView.y = BOUNDHeight - 45;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Delegate
#pragma mark - 设置ScrollerView
- (void)guideUI
{
    UIScrollView * myScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, BOUNDWidth, BOUNDHeight)];
    myScrollerView.contentSize = CGSizeMake(BOUNDWidth * 3, 0);
    myScrollerView.pagingEnabled = YES;
    myScrollerView.bounces = NO;
    myScrollerView.delegate = self;
    myScrollerView.showsVerticalScrollIndicator = NO;
    myScrollerView.showsHorizontalScrollIndicator = NO;
    _myPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(BOUNDWidth/2 - 50, BOUNDHeight - 40, 100, 20)];
    _myPageControl.numberOfPages = 3;
    _myPageControl.currentPage = 0;
    _myPageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _myPageControl.pageIndicatorTintColor = [UIColor colorWithHex:0x2667b5];
    [myScrollerView addSubview:_oneView];
    [myScrollerView addSubview:_twoView];
    [myScrollerView addSubview:_threeView];
    [myScrollerView addSubview:_pushButton];
    [self.view addSubview:myScrollerView];
    [self.view addSubview:_myPageControl];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int pageIndex = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    _myPageControl.currentPage = pageIndex;
    switch (pageIndex) {
        case 0:{
            _twoTipImageView.hidden = YES;
            _threeTipImageView.hidden = YES;
            _twoTipImageView.x = -167;
            _threeTipImageView.x = -167;
            _twoBottomImageView.y = BOUNDHeight;
            _threeBottomImageView.y = BOUNDHeight;
            _pushButton.alpha = 0;
            _oneTipImageView.hidden = NO;
            [UIView animateWithDuration:0.5 animations:^{
                _oneTipImageView.centerX = BOUNDWidth/2.0;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 animations:^{
                    _oneBottomImageView.y = BOUNDHeight - 45;
                } completion:^(BOOL finished) {
                }];
            }];
            break;
        }
        case 1:{
            _oneTipImageView.hidden = YES;
            _threeTipImageView.hidden = YES;
            _oneTipImageView.x = -167;
            _threeTipImageView.x = -167;
            _oneBottomImageView.y = BOUNDHeight;
            _threeBottomImageView.y = BOUNDHeight;
            _pushButton.alpha = 0;
            _twoTipImageView.hidden = NO;
            [UIView animateWithDuration:0.5 animations:^{
                _twoTipImageView.centerX = BOUNDWidth/2.0;
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 animations:^{
                    _twoBottomImageView.y = BOUNDHeight - 45;
                }completion:^(BOOL finished) {
                }];
            }];
            break;
        }
        case 2:{
            _oneTipImageView.hidden = YES;
            _twoTipImageView.hidden = YES;
            _oneTipImageView.x = -167;
            _twoTipImageView.x = -167;
            _twoBottomImageView.y = BOUNDHeight;
            _oneBottomImageView.y = BOUNDHeight;
            _threeTipImageView.hidden = NO;
            [UIView animateWithDuration:0.5 animations:^{
                _threeTipImageView.centerX = BOUNDWidth/2.0;
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 animations:^{
                    _threeBottomImageView.y = BOUNDHeight - 45;
                }completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.5 animations:^{
                        _pushButton.alpha = 1;
                    }completion:^(BOOL finished) {
                        
                    }];
                }];
            }];
            break;
        }
        default:
            break;
    }
}

- (void)pushLoginInAction
{
    [self pop];
}

#pragma mark - Event Responds

#pragma mark - Private Methods
- (void)configureUI{
    if (!_oneView) {
        _oneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BOUNDWidth, BOUNDHeight)];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BOUNDWidth, BOUNDHeight)];
        imageView.image = [UIImage imageNamed:[UIDevice guideResolutionWithPage:1]];
        _oneTipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-167, BOUNDHeight - 180, 167, 46)];
        _oneTipImageView.hidden = YES;
        _oneTipImageView.image = [UIImage imageNamed:@"text_one.png"];
        [_oneView addSubview:imageView];
        [_oneView addSubview:_oneTipImageView];
        _oneBottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, BOUNDHeight, BOUNDWidth, 45)];
        _oneBottomImageView.image = [UIImage imageNamed:@"bottom_circle"];
        [_oneView addSubview:_oneBottomImageView];
    }
    if (!_twoView) {
        _twoView = [[UIView alloc] initWithFrame:CGRectMake(BOUNDWidth, 0, BOUNDWidth, BOUNDHeight)];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BOUNDWidth, BOUNDHeight)];
        imageView.image = [UIImage imageNamed:[UIDevice guideResolutionWithPage:2]];
        _twoTipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-167, BOUNDHeight - 180, 167, 46)];
        _twoTipImageView.hidden = YES;
        _twoTipImageView.image = [UIImage imageNamed:@"text_two"];
        [_twoView addSubview:imageView];
        [_twoView addSubview:_twoTipImageView];
        _twoBottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, BOUNDHeight, BOUNDWidth, 45)];
        _twoBottomImageView.image = [UIImage imageNamed:@"bottom_circle"];
        [_twoView addSubview:_twoBottomImageView];
    }
    if (!_threeView) {
        _threeView = [[UIView alloc] initWithFrame:CGRectMake(BOUNDWidth * 2, 0, BOUNDWidth, BOUNDHeight)];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BOUNDWidth, BOUNDHeight)];
        imageView.image = [UIImage imageNamed:[UIDevice guideResolutionWithPage:3]];
        _threeTipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-167, BOUNDHeight - 180, 167, 46)];
        _threeTipImageView.hidden = YES;
        _threeTipImageView.image = [UIImage imageNamed:@"text_three"];
        [_threeView addSubview:imageView];
        [_threeView addSubview:_threeTipImageView];
        _threeBottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, BOUNDHeight, BOUNDWidth, 45)];
        _threeBottomImageView.image = [UIImage imageNamed:@"bottom_circle"];
        [_threeView addSubview:_threeBottomImageView];
    }
    if (!_pushButton) {
        _pushButton = [[UIButton alloc] init];
        _pushButton.frame = CGRectMake(BOUNDWidth *2 + (BOUNDWidth/2 - 84), BOUNDHeight - 110, 168, 48);
        [_pushButton setTitle:@"立即体验" forState:UIControlStateNormal];
        [_pushButton setTitleColor:[UIColor colorWithHex:0x2667b5] forState:UIControlStateNormal];
        _pushButton.titleLabel.font = [UIFont systemFontOfSize:22];
        _pushButton.backgroundColor = [UIColor whiteColor];
        _pushButton.layer.cornerRadius = 4;
        _pushButton.layer.borderColor = [UIColor colorWithHex:0x2667b5].CGColor;
        _pushButton.layer.borderWidth = 2;
        @weakify(self);
        [[_pushButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self pushLoginInAction];
        }];
    }
    [self guideUI];
}

#pragma mark - Getter & Setter


@end 
