//
//  XPDetailImageConvenienceStoreTableViewCell.m
//  XPApp
//
//  Created by iiseeuu on 16/1/20.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPDetailImageConvenienceStoreTableViewCell.h"
#import <XPAdPageView/XPADView.h>
#import <Masonry/Masonry.h>
#import <SDWebImage-ProgressView/UIImageView+ProgressView.h>
#import <XPKit/XPKit.h>
#import <UIImageView+WebCache.h>

@interface XPDetailImageConvenienceStoreTableViewCell()<XPAdViewDelegate>

@property (strong, nonatomic) XPADView *adView;
@property (weak, nonatomic) IBOutlet UIView *adCoverView;

@end
@implementation XPDetailImageConvenienceStoreTableViewCell

-(void)awakeFromNib
{
    if(!_adView) {
        _adView = [[XPADView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.adView.delegate = self;
        _adView.displayTime = 4;
        [self.adCoverView addSubview:self.adView];
        [self.adView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.bottom.mas_equalTo(0);
        }];
        [self.adView perform];
    }
   [RACObserve(self,detailModel.picUrls) subscribeNext:^(id x) {
       
       if ([x count]==1) {
           self.adView.pageControl.hidden = YES;
           self.adView.userInteractionEnabled = NO;
       }
            [self.adView setDataArray:self.detailModel.picUrls];
    }];
}

#pragma mark - XPAdPageView Delegate
- (void)adView:(XPADView *)adView lazyLoadAtIndex:(NSUInteger)index imageView:(UIImageView *)imageView imageURL:(NSString *)imageURL
{
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"common_detail_default"]];
}

-(void)adView:(XPADView *)adView didSelectedAtIndex:(NSUInteger)index imageView:(UIImageView *)imageView imagePath:(NSString *)imagePath
{
    
}

@end
