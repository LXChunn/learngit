//
//  XPVoteTableViewCell.m
//  XPApp
//
//  Created by iiseeuu on 15/12/29.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPVoteTableViewCell.h"
#import "XPTopicModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <XPKit/XPKit.h>
#import <DateTools/DateTools.h>

@interface XPVoteTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@property (weak, nonatomic) IBOutlet UILabel *participantCountLabel;


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *statuImage;

@property (weak, nonatomic) IBOutlet UIImageView *typeImage;

@property(nonatomic,strong)XPTopicModel *model;

@end

@implementation XPVoteTableViewCell

-(void)awakeFromNib
{
    RAC(self.titleLabel,text) = [RACObserve(self, model.title) ignore:nil];
    RAC(self.nicknameLabel,text) = [RACObserve(self, model.author.nickname) ignore:nil];
//    RAC(self.participantCountLabel,text) = [RACObserve(self, model.extra.participants_count) ignore:nil];
    RAC(self.participantCountLabel,text) = [RACObserve(self, model.participantStr) ignore:nil];
    RAC(self.commentCountLabel,text) = [RACObserve(self, model.commentsCount) ignore:nil];
    RAC(self.timeLabel,text) = [[RACObserve(self, model.createdAt) ignore:nil] map:^id(id value) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.model.createdAt.doubleValue];
        return[date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    }];
    
    self.typeImage.image = [ UIImage imageNamed:@"common_vote_label"];
    
    NSDate *createtime = [NSDate dateWithTimeIntervalSince1970:self.model.createdAt.doubleValue];
    NSDate *datestart = [NSDate dateWithTimeIntervalSince1970:self.model.extra.start_date.doubleValue];
    NSDate *dateend = [NSDate dateWithTimeIntervalSince1970:self.model.extra.end_date.doubleValue];
    if (createtime > datestart && createtime<dateend) {
        self.statuImage.image = [UIImage imageNamed:@"common_doing_label"];
    }else if (datestart >= createtime){
        self.statuImage.image = [UIImage imageNamed:@"common_todo_label"];
    }else if (createtime >= dateend){
        self.statuImage.image = [UIImage imageNamed:@"common_done_label"];
    }

    
    
    
}

-(void)bindModel:(id)model
{
    NSParameterAssert([model isKindOfClass:[XPTopicModel class]]);
    self.model = model;
    self.model.participantStr = [NSString stringWithFormat:@"%@人参与",self.model.extra.participants_count];
}
    



@end
