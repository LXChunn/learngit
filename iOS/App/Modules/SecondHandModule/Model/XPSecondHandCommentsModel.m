//
//  XPSecondHandCommentsModel.m
//  XPApp
//
//  Created by jy on 16/1/5.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPSecondHandCommentsModel.h"
#import "XPSecondHandReplyModel.h"

@interface XPSecondHandCommentsModel ()

@end

@implementation XPSecondHandCommentsModel

- (instancetype)init
{
    if(self = [super init]) {
    }
    
    return self;
}

- (void)loadReplyDictionary
{
    if(self.replies.count > 0) {
        if([self.replies.firstObject isKindOfClass:[XPSecondHandReplyModel class]]) {
            return;
        }
        
        NSMutableArray *array = [NSMutableArray array];
        for(NSDictionary *dic in self.replies) {
            XPSecondHandReplyModel *model = [[XPSecondHandReplyModel alloc] init];
            model.content = dic[@"content"];
            model.secondhandCommentId = dic[@"secondhand_comment_id"];
            model.createdAt = dic[@"created_at"];
            model.replyOf = dic[@"reply_of"];
            NSDictionary *authorDic = dic[@"author"];
            XPAuthorModel *authorModel = [[XPAuthorModel alloc] init];
            authorModel.nickname = authorDic[@"nickname"];
            authorModel.avatarUrl = authorDic[@"avatar_url"];
            authorModel.userId = authorDic[@"user_id"];
            model.author = authorModel;
            [array addObject:model];
        }
        self.replies = array;
    }
}

@end
