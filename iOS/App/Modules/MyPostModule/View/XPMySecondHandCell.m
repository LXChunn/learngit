//
//  XPMySecondHandCell.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/10.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "NSDate+DateTools.h"
#import "XPDetailImageShowView.h"
#import "XPMySecondHandCell.h"
#import "XPSecondHandItemsListModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <UIImageView+WebCache.h>
@interface XPMySecondHandCell ()
@property (weak, nonatomic) IBOutlet UIImageView *typeImag;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *picView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImg;
@property (nonatomic, strong) XPSecondHandItemsListModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picHeightLayout;

@end

@implementation XPMySecondHandCell

- (void)awakeFromNib
{
    self.typeImag.contentMode = UIViewContentModeScaleAspectFill;
    self.statusImg.contentMode = UIViewContentModeScaleAspectFill;
    RAC(self.titleLabel, text) = [RACObserve(self, model.title) ignore:nil];
    RAC(self.priceLabel, text) = [RACObserve(self, model.price) ignore:nil];
    RAC(self.timeLabel, text) = [[RACObserve(self, model.createdAt) ignore:nil] map:^id (id value) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.model.createdAt.doubleValue];
        return [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    }];
}

- (void)bindModel:(id)model
{
    for(UIImageView *imageView in _picView.subviews) {
        [imageView removeFromSuperview];
    }
    _model = model;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.model.createdAt.doubleValue];
    self.titleLabel.text = _model.title;
    if ([_model.price isEqualToString:@"-1"]) {
        self.priceLabel.text = @"￥面议";
    }else
    {
        self.priceLabel.text =[NSString stringWithFormat:@"￥%.2f",[_model.price floatValue]];
    }
    self.timeLabel.text = [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    if(_model.picUrls.count == 0) {
        self.picHeightLayout.constant = 0;
    }
    if([_model.status isEqualToString:@"2"]) {
        self.statusImg.image = [UIImage imageNamed:@"secondhand_complete"];
    }
    [self configureUI:_model.picUrls];
}

- (void)configureUI:(NSArray *)array
{
    if(array.count == 0) {
        return;
    }
    float kImageWitdh = ([UIScreen mainScreen].bounds.size.width - 71 - 12 - (8 * 3))/3;
    _picHeightLayout.constant = kImageWitdh;
    for(int i = 0; i < array.count; i++) {
        if(i < 3) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kImageWitdh + 25) *i, 0, kImageWitdh, kImageWitdh)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:[array objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"common_list_default"]];
            [self.picView addSubview:imageView];
        }
    }
    
}

+ (NSInteger)cellHeight:(NSArray *)arry
{
    if(arry.count == 0) {
        return 180-94+14;
    }
    
    return 180+14;
}

@end
