//
//  XPDetailAnnounceViewController.m
//  XPApp
//
//  Created by iiseeuu on 15/12/21.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPDetailAnnounceViewController.h"
#import "XPAnnouncementModel.h"
#import <UIImageView+WebCache.h>
#import <XPAdPageView/XPADView.h>
#import <Masonry/Masonry.h>
#import <SDWebImage-ProgressView/UIImageView+ProgressView.h>
#import <XPKit/XPKit.h>
#import <DateTools/DateTools.h>

@interface XPDetailAnnounceViewController ()<XPAdViewDelegate>

@property (strong, nonatomic) XPADView *adView;
@property (weak, nonatomic) IBOutlet UIView *adCoverView;
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailContentLabel;
@property (nonatomic, strong) NSArray *imageUrlArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTopLayputConstraint;

@end

@implementation XPDetailAnnounceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.isHidden){
         self.noteLabel.hidden = YES;
    }else{
        self.noteLabel.hidden = NO;
    }
    
    self.adView.delegate = self;
    [self.adCoverView addSubview:self.adView];
    [self.adView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.mas_equalTo(0);
    }];
    
    self.detailTitleLabel.text = self.detailModel.title;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.detailModel.createdAt.doubleValue];
    NSString *createtime = [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    self.detailTimeLabel.text =[NSString stringWithFormat:@"发布时间 %@",createtime];
    self.detailContentLabel.text = self.detailModel.content;
    self.imageUrlArray = self.detailModel.picUrls;
    if(_imageUrlArray.count > 0) {
        if (_imageUrlArray.count==1) {
            self.adView.pageControl.hidden = YES;
            self.adView.userInteractionEnabled = NO;
        }
        [self.adView setDataArray:self.imageUrlArray];
        [self.adView perform];
        _lineTopLayputConstraint.constant = 25 + (self.view.bounds.size.width - 38)*2/3;
    } else {
        _lineTopLayputConstraint.constant = 13;
    }
    switch ([self.detailModel.type intValue]) {
        case 1:
            self.noteLabel.text = @"政府公告";
            break;
        case 2:
             self.noteLabel.text = @"社区公告";
            break;
        case 3:
             self.noteLabel.text = @"资讯公告";
            break;
        case 100:
             self.noteLabel.text = @"其他";
            break;
        default:
            break;
    }
}

#pragma mark - XPAdPageView Delegate
- (void)adView:(XPADView *)adView didSelectedAtIndex:(NSUInteger)index imageView:(UIImageView *)imageView imagePath:(NSString *)imagePath
{
    
}

- (void)adView:(XPADView *)adView lazyLoadAtIndex:(NSUInteger)index imageView:(UIImageView *)imageView imageURL:(NSString *)imageURL
{
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
   [imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"common_detail_default"]];
}


#pragma mark - Delegate

#pragma mark - Event Responds

#pragma mark - Private Methods

#pragma mark - Getter & Setter
- (XPADView *)adView
{
    if(!_adView) {
//        float adWidth = [UIScreen mainScreen].bounds.size.width - 78;
        _adView = [[XPADView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _adView.displayTime = 4;
    }
    return _adView;
}

@end
