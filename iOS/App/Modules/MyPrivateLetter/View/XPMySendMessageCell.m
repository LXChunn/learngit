//
//  XPMySendMessageCell.m
//  XPApp
//
//  Created by jy on 16/1/9.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "NSDate+DateTools.h"
#import "UIView+HESizeHeight.h"
#import "XPLoginModel.h"
#import "XPMessageDetailModel.h"
#import "XPMySendMessageCell.h"
#import <UIImageView+WebCache.h>
#define BoundWidth [UIScreen mainScreen].bounds.size.width

@interface XPMySendMessageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftWidthLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *sendMessageImageView;
@property (nonatomic, strong) XPMessageDetailModel *model;
@property (nonatomic, strong) ClickAvatorBlock block;
@end

@implementation XPMySendMessageCell

- (void)awakeFromNib
{
    self.avatorImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatorImageView.clipsToBounds = YES;
    [self.avatorImageView whenTapped:^{
        if(_block) {
            _block();
        }
    }];
    [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:[XPLoginModel singleton].avatarUrl] placeholderImage:[UIImage imageNamed:@"common_default_avatar"]];
    UIEdgeInsets insets = UIEdgeInsetsMake(40, 16, 30, 36);
    UIImage *image = [UIImage imageNamed:@"me_message_blue"];
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.sendMessageImageView.image = image;
}

- (void)whenClickAvatorWithBlock:(ClickAvatorBlock)block
{
    _block = block;
}

- (void)bindModel:(XPBaseModel *)model
{
    if(!model) {
        return;
    }
    
    _model = (XPMessageDetailModel *)model;
    [self configureUI];
}

- (void)configureUI
{
    self.contentLabel.text = self.model.content;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.model.createdAt doubleValue]];
    NSString *time = [date formattedDateWithFormat:@"YYYY-MM-dd  hh:mm"];
    self.timeLabel.text = time;
    float contentHeight = [UIView getTextSizeHeight:self.model.content font:14 withSize:CGSizeMake(BoundWidth - 161, MAXFLOAT)];
    float timeWidth = [UIView getTextSizeWidth:time font:14 withSize:CGSizeMake(MAXFLOAT, 16)];
    if(contentHeight > 21) {
        //多行
        self.leftWidthLayoutConstraint.constant = 58;
    } else {
        //单行
        float contentWidth = [UIView getTextSizeWidth:self.model.content font:14 withSize:CGSizeMake(MAXFLOAT, 16)];
        if(contentWidth < timeWidth) {
            self.leftWidthLayoutConstraint.constant = BoundWidth - 90 - timeWidth - 15;
        } else {
            self.leftWidthLayoutConstraint.constant = BoundWidth - 90 - contentWidth - 15;
        }
    }
}

@end
