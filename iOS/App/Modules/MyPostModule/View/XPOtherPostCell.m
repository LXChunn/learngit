//
//  XPOtherPostCell.m
//  XPApp
//
//  Created by CaoShunQing on 16/2/22.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPOtherPostCell.h"
#import "XPOtherForumModel.h"
#import "NSDate+DateTools.h"
#import <UIImageView+WebCache.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface XPOtherPostCell()
@property (weak, nonatomic) IBOutlet UIImageView *statusImgaeView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *picView;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picHeightLayout;
@property (nonatomic,strong) XPOtherForumModel *model;
@end

@implementation XPOtherPostCell

- (void)awakeFromNib
{

}

- (void)bindModel:(id)model
{
    for(UIImageView *imageView in _picView.subviews) {
        [imageView removeFromSuperview];
    }
    _model = model;
    if ([self.model.type isEqualToString:@"5"]) {
        self.typeImageView.image = [UIImage imageNamed:@"label_household"];
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.model.createdAt.doubleValue];
    self.titleLabel.text = _model.title;

    self.timeLabel.text = [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    if(_model.picUrls.count == 0) {
        self.picHeightLayout.constant = 0;
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

+ (NSInteger)cellHeight:(NSArray *)array
{
    if(array.count == 0) {
        return 180-94+14;
    }
    
    return 180+14;
}
@end
