//
//  XPMyOtherFavoriteCell.m
//  XPApp
//
//  Created by CaoShunQing on 16/2/23.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPMyOtherFavoriteCell.h"
#import "XPOtherFavoriateModel.h"
#import <UIImageView+WebCache.h>
#import "NSDate+DateTools.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface XPMyOtherFavoriteCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *picsView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (nonatomic, strong) XPOtherFavoriateModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picViewHeightLayout;

@end

@implementation XPMyOtherFavoriteCell

- (void)awakeFromNib {

    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    RAC(self.titleLabel,text) = [RACObserve(self, model.title) ignore:nil];
    RAC(self.nickNameLabel,text) = [RACObserve(self, model.author.nickname) ignore:nil];
    RAC(self.timeLabel,text) = [[RACObserve(self, model.createdAt) ignore:nil] map:^id(id value) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.model.favoriteItemId.doubleValue];
        return [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    }];
    RAC(self.typeLabel,text) = [RACObserve(self, model.type) ignore:nil];
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
    self.titleLabel.text = self.model.title;
    self.nickNameLabel.text = self.model.author.nickname;
    self.timeLabel.text =[NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSince1970:self.model.favoriteItemId.doubleValue]];
    if ([self.model.type isEqualToString:@"5"]) {
        self.typeLabel.text = @"家政资讯";
    }
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 19;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_model.author.avatarUrl] placeholderImage:[UIImage imageNamed:@"common_default_avatar"]];
    
    if(_model.picUrls.count > 0) {
        _picViewHeightLayout.constant = 86;
        _picsView.hidden = NO;
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
        _picViewHeightLayout.constant = 0;
        _picsView.hidden = YES;
    }
}

- (void)conFigUi:(NSArray *)array
{
    for(UIImageView *imageView in _picsView.subviews) {
        [imageView removeFromSuperview];
    }
    float kImageWitdh = ([UIScreen mainScreen].bounds.size.width - 71 - 12 - (8 * 3))/3;
    for(int i = 0; i < array.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kImageWitdh + 8) *i, 0, kImageWitdh, kImageWitdh)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[array objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"common_list_default"]];
        [_picsView addSubview:imageView];
    }
    _picViewHeightLayout.constant = kImageWitdh;
}
@end
