//
//  XPShareAlertController.m
//  XPApp
//
//  Created by jy on 16/1/12.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPShareAlertController.h"
#import "XPShareCollectionViewCell.h"
#import <UIColor+XPKit.h>

static const CGFloat xp_topTipHeight = 10;
static const CGFloat xp_AlertCancelButtonHeight = 48;
static const CGFloat xp_CellWidth = 100;
static const CGFloat xp_CellHeight = 105;
static const CGFloat xp_SpaceHeight = 8;

#define BoundsWidth [UIScreen mainScreen].bounds.size.width
@interface XPShareAlertController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *actionActivities;
@property (nonatomic, strong) NSArray *actionImagesActivities;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *interateView;
@property (nonatomic, strong) UIView *containerView;
@end

@implementation XPShareAlertController

- (instancetype)initWithActivity:(NSArray *)activitys
{
    if(self = [self initWithFrame:[UIScreen mainScreen].bounds]) {
        _actionActivities = @[@"微信",@"朋友圈",@"QQ"];
        _actionImagesActivities = @[@"sns_icon_wechat",@"sns_icon_friend",@"sns_icon_qq"];
        [self configAllUI];
    }
    return self;
}

- (void)show
{
    [self makeKeyAndVisible];
    [self showAnimaiton];
}

#pragma mark - Private Methods
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        self.windowLevel = UIWindowLevelAlert;
        // 这里，不能设置UIWindow的alpha属性，会影响里面的子view的透明度，这里我们用一张透明的图片
        // 设置背影半透明
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)configAllUI
{
    [self configInteratieView];
    
    self.containerView = [[UIView alloc] initWithFrame:(CGRect){0, self.bounds.size.height-xp_topTipHeight-xp_CellHeight-xp_AlertCancelButtonHeight-xp_SpaceHeight , self.bounds.size.width, xp_topTipHeight+xp_CellHeight+xp_SpaceHeight+xp_AlertCancelButtonHeight}];
    self.containerView.backgroundColor = [UIColor colorWithWhite:0.871 alpha:1.000];
    [self addSubview:self.containerView];
    
    UIView * tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BoundsWidth, xp_topTipHeight)];
    tipView.backgroundColor = [UIColor whiteColor];
    [self.containerView addSubview:tipView];
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,xp_topTipHeight,self.bounds.size.width,xp_CellHeight) collectionViewLayout:flowLayout];
    self.collectionView.scrollEnabled = NO;
    self.collectionView.userInteractionEnabled = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[XPShareCollectionViewCell class] forCellWithReuseIdentifier:@"XPShareCollectionViewCell"];
    [self.containerView addSubview:self.collectionView];
    self.cancelButton = [[UIButton alloc] initWithFrame:(CGRect){0, self.containerView.bounds.size.height - xp_AlertCancelButtonHeight, self.bounds.size.width, xp_AlertCancelButtonHeight}];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    self.cancelButton.opaque = NO;
    self.cancelButton.backgroundColor = [UIColor whiteColor];
    [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.cancelButton];
}

- (void)configInteratieView
{
    self.interateView = [[UIView alloc] initWithFrame:self.bounds];
    [self.interateView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonClick:)]];
    self.interateView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [self addSubview:self.interateView];
}

- (void)showAnimaiton
{
    self.hidden = NO;
    CGFloat y = self.containerView.frame.origin.y;
    self.containerView.frame = (CGRect){0, self.bounds.size.height, self.containerView.bounds.size};
    [UIView animateWithDuration:0.5 delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.containerView.frame = (CGRect){0, y, self.containerView.bounds.size};
                     }
                     completion:^(BOOL finished) {
                         self.userInteractionEnabled = YES;
                     }];
}

- (void)dismissWithAnimation
{
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.9
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.containerView.frame = (CGRect){0, self.bounds.size.height, self.containerView.bounds.size};
                         self.interateView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         self.userInteractionEnabled = YES;
                         [self.cancelButton removeFromSuperview];
                         [self.collectionView removeFromSuperview];
                         [self.containerView removeFromSuperview];
                         [self.interateView removeFromSuperview];
                         [self resignKeyWindow];
                         [self setHidden:YES];
                         [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
                     }];
}

- (void)cancelButtonClick:(id)sender
{
    [self dismissWithAnimation];
}

#pragma mark - UICollectionViewDelegateAndDatasource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XPShareCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XPShareCollectionViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = _actionActivities[indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:_actionImagesActivities[indexPath.row]];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _actionActivities.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(xp_CellWidth, xp_CellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, (BoundsWidth - xp_CellWidth * 3)/4, 10, (BoundsWidth - xp_CellWidth * 3)/4);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissWithAnimation];
    if(self.delegate && [self.delegate respondsToSelector:@selector(shareController:didSelectRow:)]) {
        [self.delegate shareController:self didSelectRow:indexPath.row];
    }
}





@end
