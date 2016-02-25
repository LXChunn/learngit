//
//  XPSecondHandCell.m
//  XPApp
//
//  Created by jy on 15/12/29.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPSecondHandCell.h"
#import "XPSecondHandItemsListModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <XPKit/XPKit.h>
#import <DateTools/DateTools.h>
#import "XPAuthorModel.h"
#import <UIImageView+AFNetworking.h>

@interface XPSecondHandCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *goodsView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *completedImageView;
@property (nonatomic,strong) XPSecondHandItemsListModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictureHeightLayoutConstraint;


@end

@implementation XPSecondHandCell

+ (NSInteger)cellHeightWithArray:(NSArray *)images
{
    if (images.count <= 0)
    {
        return 106;
    }
    return 199;
}

- (void)bindModel:(id)model
{
    NSParameterAssert([model isKindOfClass:[XPSecondHandItemsListModel class]]);
    _model = model;
    [self configureUI];
}

- (void)configureUI
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_model.createdAt.doubleValue];
    self.nickNameLabel.text = _model.author.nickname;
    self.timeLabel.text = [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    [self.avatorImageView setImageWithURL:[NSURL URLWithString:_model.author.avatarUrl] placeholderImage:nil];
    self.contentLabel.text = _model.title;
    if ([_model.status isEqualToString:@"1"])
    {
        self.completedImageView.hidden = YES;
    }
    else if ([_model.status isEqualToString:@"2"])
    {
        self.completedImageView.hidden = NO;
    }
    NSString * price;
    if (_model.price == -1)
    {
        price = @"价格面议";
    }
    else
    {
        price = [@(_model.price) stringValue];
    }
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",price];
    if (_model.picUrls.count > 0)
    {
        _pictureHeightLayoutConstraint.constant = 86;
        if (_model.picUrls.count > 3)
        {
            NSMutableArray *images = [NSMutableArray array];
            for (int i = 0 ; i < 3 ; i++)
            {
                [images addObject:[_model.picUrls objectAtIndex:i]];
            }
            [self configurePictureUIWithImageArray:images];
        }
        else
        {
            [self configurePictureUIWithImageArray:_model.picUrls];
        }
    }
    else
    {
        _pictureHeightLayoutConstraint.constant = 0;
    }
}

- (void)configurePictureUIWithImageArray:(NSArray *)images
{
    for (UIImageView * imageView in _goodsView.subviews)
    {
        [imageView removeFromSuperview];
    }
    for (int i = 0 ; i < images.count ; i++)
    {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((86 + 8) *i, 0, 86, 86)];
        [imageView setImageWithURL:[NSURL URLWithString:[images objectAtIndex:i]] placeholderImage:nil];
        [_goodsView addSubview:imageView];
    }
}

@end
