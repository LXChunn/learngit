//
//  XPAPIManager+XPAPIManager+Vote.m
//  XPApp
//
//  Created by Mac OS on 15/12/30.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "NSString+XPAPIPath_Vote.h"
#import "XPAPIManager+Analysis.h"
#import "XPAPIManager+Vote.h"
#import "XPSecondHandCommentsModel.h"
#import "XPVoteModel.h"
#import <XPKit.h>

@implementation XPAPIManager (Vote)

- (RACSignal *)postVoteWithtitle:(NSString *)title content:(NSString *)content type:(NSString *)type withoptions:(NSArray *)options
{
    NSParameterAssert(content);
    NSParameterAssert(type);
    NSParameterAssert(title);
    NSMutableDictionary *parameters = [@{@"title":title,
                                         @"content":content,
                                         @"type":type,
                                         @"options":options.arrayToJson}
                                       mutableCopy];
    return [[[[[self rac_POST:[NSString api_releasvote_path] parameters:[[parameters fillUserInfo]                      fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return :value];
    }] logError] replayLazily];
}

- (RACSignal *)voteDetailWithforumTopicId:(NSString *)forumTopicId
{
    return [[[[[self rac_POST:[NSString api_vote_path] parameters:[[@{@"forum_topic_id":forumTopicId}
                                                                    fillUserInfo]fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        
        return [self rac_MappingForClass:[XPVoteModel class] dictionary:value];
    }] logError] replayLazily];
}

- (RACSignal *)voteWithforumTopicId:(NSString *)forumTopicId voteOptionId:(NSString *)voteOptionId
{
    return [[[[[self rac_POST:[NSString api_from_topic_vote_path] parameters:[[@{@"forum_topic_id":forumTopicId, @"vote_option_id":voteOptionId}
                                                                               fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return:@"success"];
    }] logError] replayLazily];
}

- (RACSignal *)forumCommentsWithForunTopicId:(NSString *)forumTopicId forumCommentId:(NSString *)forumCommentId
{
    NSMutableDictionary *dic = [@{@"forum_topic_id":forumTopicId}
                                mutableCopy];
    if(forumCommentId.length > 0) {
        [dic setValue:forumCommentId forKey:@"forum_comment_id"];
    }
    
    return [[[[[self rac_GET:[NSString api_forum_comments_path] parameters:[[dic fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        
        return [self rac_MappingForClass:[XPSecondHandCommentsModel class] array:[value objectForKey:@"forum_comments"]];
    }] logError] replayLazily];
}

- (RACSignal *)reolyFroumCommentWithForumTopicId:(NSString *)forumTopicId content:(NSString *)content replyOf:(NSString *)replyOf
{
    NSMutableDictionary *dic = [@{@"forum_topic_id":forumTopicId,
                                  @"content":content}
                                mutableCopy];
    if(replyOf.length > 0) {
        [dic setValue:replyOf forKey:@"reply_of"];
    }
    
    return [[[[[self rac_POST:[NSString api_forum_comment_create_path] parameters:[[dic fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        
        return [self rac_MappingForClass:[XPSecondHandCommentsModel class] dictionary:value];
    }] logError] replayLazily];
}

@end
