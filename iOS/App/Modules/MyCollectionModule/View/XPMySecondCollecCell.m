//
//  XPMySecondCollecCell.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/10.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "NSDate+DateTools.h"
#import "XPDetailImageShowView.h"
#import "XPMySecondCollecCell.h"
#import "XPSecondHandItemsListModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <UIImageView+WebCache.h>

@interface XPMySecondCollecCell ()
@property (weak, nonatomic) IBOutlet UIImageView *statusImg;
@property (weak, nonatomic) IBOutlet XPDetailImageShowView *ImgsView;
@property (weak, nonatomic) IBOutlet UIImageView *avataImg;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) XPSecondHandItemsListModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgsHeightLayout;

@end

@implementation XPMySecondCollecCell

- (void)awakeFromNib
{
    self.statusImg.contentMode = UIViewContentModeScaleAspectFill;
    self.avataImg.contentMode = UIViewContentModeScaleAspectFill;
}

+ (NSInteger)heightForCell:(NSArray *)arry
{
    if(arry.count == 0) {
        return 207-94;
    }
    return 207;
}

- (void)bindModel:(id)model
{
    _model = model;
    self.titleLabel.text = _model.title;
    self.nickNameLabel.text = _model.author.nickname;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.model.createdAt.doubleValue];
    self.timeLabel.text = [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    self.priceLabel.text = [NSString stringWithFormat:@"￥ %@", _model.price];
    if([_model.price isEqualToString:@"-1"]) {
        self.priceLabel.text = @"￥面议";
    }
    if([_model.status isEqualToString:@"2"]) {
        self.statusImg.image = [UIImage imageNamed:@"secondhand_complete"];
    }
    
    self.avataImg.layer.masksToBounds = YES;
    self.avataImg.layer.cornerRadius = 19;
    [self.avataImg sd_setImageWithURL:[NSURL URLWithString:_model.author.avatarUrl] placeholderImage:[UIImage imageNamed:@"common_default_avatar"]];
    
    if(_model.picUrls.count > 0) {
        _imgsHeightLayout.constant = 86;
        _ImgsView.hidden = NO;
        if(_model.picUrls.count > 3) {
            NSMutableArray *images = [NSMutableArray array];
            for(int i = 0; i < 3; i++) {
                [images addObject:[_model.picUrls objectAtIndex:i]];
            }
            [self conFigUi:images];
        } else {
            [self conFigUi:_model.picUrls];
        }
    } else {
        _imgsHeightLayout.constant = 0;
        _ImgsView.hidden = YES;
    }
}

- (void)conFigUi:(NSArray *)array
{
    for(UIImageView *imageView in _ImgsView.subviews) {
        [imageView removeFromSuperview];
    }
    float kImageWitdh = ([UIScreen mainScreen].bounds.size.width - 71 - 12 - (8 * 3))/3;
    for(int i = 0; i < array.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kImageWitdh + 8) *i, 0, kImageWitdh, kImageWitdh)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[array objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"common_list_default"]];
        [_ImgsView addSubview:imageView];
    }
    _imgsHeightLayout.constant = kImageWitdh;
}
@end
