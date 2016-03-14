//
//  XPMyPrivateLetterListCell.m
//  XPApp
//
//  Created by jy on 16/1/9.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "NSDate+DateTools.h"
#import "XPMessageListModel.h"
#import "XPMyPrivateLetterListCell.h"
#import <M13BadgeView/M13BadgeView.h>
#import <UIImageView+WebCache.h>
@interface XPMyPrivateLetterListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) XPMessageListModel *model;
@property (nonatomic, retain) M13BadgeView *badgeView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@end

@implementation XPMyPrivateLetterListCell

- (void)awakeFromNib
{
    
}

- (void)bindModel:(XPBaseModel *)model
{
    if(!model) {
        return;
    }
    _model = (XPMessageListModel *)model;
    [self configureUI];
}

- (void)configureUI
{
    if (!_badgeView){
        _badgeView = [[M13BadgeView alloc] initWithFrame:CGRectMake(0, 0, 16.0, 16.0)];
        _badgeView.hidesWhenZero = YES;
        _badgeView.font = [UIFont systemFontOfSize:12];
        _badgeView.horizontalAlignment = M13BadgeViewHorizontalAlignmentRight;
        _badgeView.verticalAlignment = M13BadgeViewVerticalAlignmentTop;
        [self.coverImageView addSubview:_badgeView];
    }
    self.nickNameLabel.text = _model.contact.nickname;
    self.contentLabel.text = _model.lastMessageContent;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.model.lastMessageDate doubleValue]];
    self.timeLabel.text = [date formattedDateWithFormat:@"YYYY-MM-dd  hh:mm"];
    self.avatorImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatorImageView.clipsToBounds = YES;
    [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:self.model.contact.avatarUrl] placeholderImage:[UIImage imageNamed:@"common_default_avatar"]];
    _badgeView.text = [@(self.model.unreadMessagesCount)stringValue];
}

@end
