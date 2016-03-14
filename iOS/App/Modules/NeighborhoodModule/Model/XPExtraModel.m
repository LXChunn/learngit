//
//  XPExtraModel.m
//  XPApp
//
//  Created by iiseeuu on 15/12/28.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPAuthorModel.h"
#import "XPExtraModel.h"
#import "XPOptionModel.h"

@interface XPExtraModel ()

@end

@implementation XPExtraModel

- (void)dictionaryWithOptions
{
    if(self.options.count > 0) {
        if([self.options.firstObject isKindOfClass:[XPOptionModel class]]) {
            return;
        }
        
        NSMutableArray *optionsArray = [NSMutableArray array];
        for(NSDictionary *dic in self.options) {
            XPOptionModel *model = [[XPOptionModel alloc] init];
            model.descriptionField = dic[@"description"];
            model.voteOptionId = dic[@"vote_option_id"];
            model.votesCount = [dic[@"votes_count"] integerValue];
            [optionsArray addObject:model];
        }
        self.options = optionsArray;
    }
}

- (void)dictionaryWithParticipants
{
    if(self.participants.count > 0) {
        if([self.participants.firstObject isKindOfClass:[XPAuthorModel class]]) {
            return;
        }
        
        NSMutableArray *participantsArray = [NSMutableArray array];
        for(NSDictionary *dic in self.participants) {
            XPAuthorModel *authorModel = [[XPAuthorModel alloc] init];
            authorModel.userId = dic[@"user_id"];
            authorModel.avatarUrl = dic[@"avatar_url"];
            authorModel.nickname = dic[@"nickname"];
            [participantsArray addObject:authorModel];
        }
        self.participants = participantsArray;
    }
}

@end
