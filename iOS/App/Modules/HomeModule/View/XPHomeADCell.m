//
//  XPHomeADCell.m
//  XPApp
//
//  Created by jy on 16/1/14.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPHomeADCell.h"
#import <XPADView.h>
#import <UIImageView+WebCache.h>
#import <UIImageView+AFNetworking.h>
#define BoundWidth [UIScreen mainScreen].bounds.size.width

@interface XPHomeADCell ()<XPAdViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *adDefaultImageView;
@property (nonatomic,strong) XPADView *adView;
@property (weak, nonatomic) IBOutlet UIView *adCoverView;
@property (nonatomic,strong) ClickImageBlock block;
@end

@implementation XPHomeADCell

- (void)awakeFromNib{
    if (!_adView) {
        _adView = [[XPADView alloc] initWithFrame:CGRectMake(0, 0, BoundWidth, BoundWidth * 11.0/38.0)];
//        _adView.backgroundColor = [UIColor redColor];
        _adView.displayTime = 4;
        _adView.delegate = self;
        [self.adView perform];
        [self.adCoverView addSubview:self.adView];
    }
}

+ (float)cellHeight{
    float height = BoundWidth * 11.0/38.0;
    return 8 + height;
}

- (void)configureUIWithImages:(NSArray *)images clickBlock:(ClickImageBlock)block{
    _block = block;
    if (images.count > 0) {
        if (images.count ==1) {
            self.adView.pageControl.hidden = YES;
        }
        self.adDefaultImageView.hidden = YES;
        [self.adView setDataArray:images];
    }else{
        self.adDefaultImageView.hidden = NO;
    }
}

#pragma mark - XPAdPageView Delegate
- (void)adView:(XPADView *)adView didSelectedAtIndex:(NSUInteger)index imageView:(UIImageView *)imageView imagePath:(NSString *)imagePath
{
    if (_block) {
        _block(index);
    }
}

- (void)adView:(XPADView *)adView lazyLoadAtIndex:(NSUInteger)index imageView:(UIImageView *)imageView imageURL:(NSString *)imageURL
{
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"common_ad_default"]];
}

@end
