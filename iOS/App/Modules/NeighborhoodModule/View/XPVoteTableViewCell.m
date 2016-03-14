//
//  XPVoteTableViewCell.m
//  XPApp
//
//  Created by iiseeuu on 15/12/29.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPMyCommentListModel.h"
#import "XPTopicModel.h"
#import "XPVoteTableViewCell.h"
#import <DateTools/DateTools.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <XPKit/XPKit.h>

@interface XPVoteTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@property (weak, nonatomic) IBOutlet UILabel *participantCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *statuImage;

@property (weak, nonatomic) IBOutlet UIImageView *typeImage;

@property (nonatomic, strong) XPTopicModel *model;
@property (weak, nonatomic) IBOutlet UIButton *mesagerIMG;

@end

@implementation XPVoteTableViewCell

- (void)awakeFromNib
{
    self.typeImage.image = [ UIImage imageNamed:@"common_vote_label"];
    RAC(self.titleLabel, text) = [RACObserve(self, model.title) ignore:nil];
    RAC(self.nicknameLabel, text) = [RACObserve(self, model.author.nickname) ignore:nil];
    RAC(self.participantCountLabel, text) = [RACObserve(self, model.participantStr) ignore:nil];
    RAC(self.commentCountLabel, text) = [RACObserve(self, model.commentsCount) ignore:nil];
    RAC(self.timeLabel, text) = [[RACObserve(self, model.createdAt) ignore:nil] map:^id (id value) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        return [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    }];
    [[RACObserve(self, model.extra.open) ignore:nil] subscribeNext:^(id x) {
        if(self.model.extra.open) {
            self.statuImage.image = [UIImage imageNamed:@"common_doing_label"];
        } else {
            self.statuImage.image = [UIImage imageNamed:@"common_close_label"];
        }
    }];
}

- (void)bindModel:(id)model
{
    NSParameterAssert([model isKindOfClass:[XPTopicModel class]]);
    self.model = model;
    self.model.participantStr = [NSString stringWithFormat:@"%@人参与", self.model.extra.participantsCount];
    if([self isBlankString:self.model.extra.participantsCount]) {
        self.model.participantStr = @"0人参与";
    }
}

- (BOOL)isBlankString:(NSString *)string
{
    if(string == nil || string == NULL) {
        return YES;
    }
    if([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    
    return NO;
}

- (void)hidden
{
    self.statuImage.hidden = YES;
    self.typeImage.hidden = YES;
    self.commentCountLabel.hidden = YES;
    self.mesagerIMG.hidden = YES;
    
}

- (void)hiddenForMyPost
{
    self.nicknameLabel.hidden = YES;
    self.participantCountLabel.hidden = YES;
}

- (void)hiddenForNeighborhood
{
    self.participantCountLabel.hidden = YES;
}
@end
