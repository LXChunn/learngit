//
//  XPAPIManager+XPAPIManager+Vote.h
//  XPApp
//
//  Created by Mac OS on 15/12/30.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager.h"

@interface XPAPIManager (Vote)

- (RACSignal *)postVoteWithtitle:(NSString *)title content:(NSString *)content type:(NSString *)type withoptions:(NSArray *)options;

- (RACSignal *)voteDetailWithforumTopicId:(NSString *)forumTopicId;

- (RACSignal *)voteWithforumTopicId:(NSString *)forumTopicId voteOptionId:(NSString *)voteOptionId;

- (RACSignal *)forumCommentsWithForunTopicId:(NSString *)forumTopicId forumCommentId:(NSString *)forumCommentId;

- (RACSignal *)reolyFroumCommentWithForumTopicId:(NSString *)forumTopicId content:(NSString *)content replyOf:(NSString *)replyOf;

@end
