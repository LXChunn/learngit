//
//  XPSecondHandCell.m
//  XPApp
//
//  Created by jy on 15/12/29.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPAuthorModel.h"
#import "XPSecondHandCell.h"
#import "XPSecondHandItemsListModel.h"
#import "XPTopicModel.h"
#import <DateTools/DateTools.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <UIImageView+WebCache.h>
#import <XPKit/XPKit.h>
#
@interface XPSecondHandCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *goodsView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *completedImageView;
@property (nonatomic, strong) XPSecondHandItemsListModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictureHeightLayoutConstraint;

@end

@implementation XPSecondHandCell

+ (NSInteger)cellHeightWithArray:(NSArray *)images
{
    float kImageWitdh = ([UIScreen mainScreen].bounds.size.width - 71 - 12 - (8 * 3))/3;
    if(images.count <= 0) {
        return 106;
    }
    
    return 113 + kImageWitdh;
}

- (void)bindModel:(id)model
{
    _model = model;
    [self configureUI];
}

- (void)configureUI
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_model.createdAt.doubleValue];
    self.nickNameLabel.text = _model.author.nickname;
    self.timeLabel.text = [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    self.avatorImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:_model.author.avatarUrl] placeholderImage:[UIImage imageNamed:@"common_default_avatar"]];
    self.contentLabel.text = _model.title;
    if([_model.status isEqualToString:@"1"]) {
        self.completedImageView.hidden = YES;
    } else if([_model.status isEqualToString:@"2"]) {
        self.completedImageView.hidden = NO;
    }
    
    NSString *price;
    if([_model.price integerValue] == -1) {
        price = @"￥面议";
        self.priceLabel.text = price;
    } else {
        price = _model.price;
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.02f", [price floatValue]];
    }
    if(_model.picUrls.count > 0) {
        _pictureHeightLayoutConstraint.constant = 86;
        _goodsView.hidden = NO;
        if(_model.picUrls.count > 3) {
            NSMutableArray *images = [NSMutableArray array];
            for(int i = 0; i < 3; i++) {
                [images addObject:[_model.picUrls objectAtIndex:i]];
            }
            [self configurePictureUIWithImageArray:images];
        } else {
            [self configurePictureUIWithImageArray:_model.picUrls];
        }
    } else {
        _pictureHeightLayoutConstraint.constant = 0;
        _goodsView.hidden = YES;
    }
}

- (void)configurePictureUIWithImageArray:(NSArray *)images
{
    for(UIImageView *imageView in _goodsView.subviews) {
        [imageView removeFromSuperview];
    }
    float kImageWitdh = ([UIScreen mainScreen].bounds.size.width - 71 - 12 - (8 * 3))/3;
    for(int i = 0; i < images.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kImageWitdh + 8) *i, 0, kImageWitdh, kImageWitdh)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[images objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"common_list_default"]];
        [_goodsView addSubview:imageView];
    }
    _pictureHeightLayoutConstraint.constant = kImageWitdh;
}

@end
