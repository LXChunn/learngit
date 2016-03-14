//
//  XPHousekeepingNewsListCell.m
//  XPApp
//
//  Created by jy on 16/2/22.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPHousekeepingNewsListCell.h"
#import <NSDate+DateTools.h>
#import <UIImageView+WebCache.h>
#import <XPKit/XPKit.h>

@interface XPHousekeepingNewsListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *goodsView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong) XPHousekeepingListModel * listModel;

@end

@implementation XPHousekeepingNewsListCell

+ (float)cellHeight:(XPHousekeepingListModel *)model{
    float kImageWitdh = ([UIScreen mainScreen].bounds.size.width - 68 - 25 - (8 * 3))/3;
    if(model.picUrls.count < 1) {
        return 88;
    }
    return 100 + kImageWitdh;
}

- (void)awakeFromNib {
    @weakify(self);
    RAC(self.contentLabel,text) = [RACObserve(self,listModel.title) ignore:nil];
    RAC(self.nickNameLabel,text) = [RACObserve(self,listModel.author.nickname) ignore:nil];

    [[RACObserve(self,listModel.picUrls) ignore:nil] subscribeNext:^(NSArray * x) {
        @strongify(self);
        if(x.count > 3) {
            NSMutableArray *images = [NSMutableArray array];
            for(int i = 0; i < 3; i++) {
                [images addObject:[x objectAtIndex:i]];
            }
            [self configurePictureUIWithImageArray:images];
        } else {
            [self configurePictureUIWithImageArray:_listModel.picUrls];
        }
    }];
    [[RACObserve(self,listModel.createdAt) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[x doubleValue]];
        self.timeLabel.text = [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    }];
    [[RACObserve(self,listModel.author.avatarUrl) ignore:nil] subscribeNext:^(id x) {
        self.avatorImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:x] placeholderImage:[UIImage imageNamed:@"common_default_avatar"]];
    }];
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
}

- (void)bindModel:(XPHousekeepingListModel *)model{
    if(!model) {
        return;
    }
    NSParameterAssert([model isKindOfClass:[XPHousekeepingListModel class]]);
    self.listModel = model;
}

@end
