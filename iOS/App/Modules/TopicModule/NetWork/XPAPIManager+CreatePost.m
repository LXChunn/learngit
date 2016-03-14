//
//  XPAPIManager+CreatePost.m
//  XPApp
//
//  Created by iiseeuu on 15/12/30.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "NSString+XPAPIPath_CreatePost.h"
#import "XPAPIManager+Analysis.h"
#import "XPAPIManager+CreatePost.h"
#import "XPDetailPostModel.h"
#import <XPKit.h>

@implementation XPAPIManager (CreatePost)

- (RACSignal *)createPostWithTitle:(NSString *)title type:(NSString *)type content:(NSString *)content picUrls:(NSArray *)picUrls
{
    NSParameterAssert(content);
    NSParameterAssert(type);
    NSParameterAssert(title);
    NSMutableDictionary *parameters = [@{
                                         @"content":content,
                                         @"type":type,
                                         @"title":title
                                         }
                                       mutableCopy];
    if(picUrls) {
        [parameters setObject:picUrls.arrayToJson forKey:@"pic_urls"];
    }
    
    return [[[[[self rac_POST:[NSString api_createpost_path] parameters:[[parameters fillUserInfo]                      fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return :value];
    }] logError] replayLazily];
}

- (RACSignal *)createEventPostWithTitle:(NSString *)title type:(NSString *)type content:(NSString *)content picUrls:(NSArray *)picUrls startDate:(NSString *)startDate endDate:(NSString *)endDate
{
    NSParameterAssert(content);
    NSParameterAssert(type);
    NSParameterAssert(title);
    NSParameterAssert(startDate);
    
    NSMutableDictionary *parameters = [@{
                                         @"content":content,
                                         @"type":type,
                                         @"title":title,
                                         @"start_date":startDate
                                         }
                                       mutableCopy];
    if(picUrls.count > 0) {
        [parameters setObject:picUrls.arrayToJson forKey:@"pic_urls"];
    }
    if(endDate.length > 0) {
        [parameters setObject:endDate forKey:@"end_date"];
    }
    
    return [[[[[self rac_POST:[NSString api_createpost_path] parameters:[[parameters fillUserInfo]                      fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return :value];
    }] logError] replayLazily];
}

- (RACSignal *)detailPostWithForumtopicid:(NSString *)forumtopicId
{
    return [[[[[self rac_GET:[NSString api_detailpost_path] parameters:[[ @{@"forum_topic_id" : forumtopicId}
                                                                         fillUserInfo]                        fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        
        return [self rac_MappingForClass:[XPDetailPostModel class] dictionary:value];
    }] logError] replayLazily];
}

- (RACSignal *)deletePostWithForumtopicid:(NSString *)forumtopicId
{
    return [[[[[self rac_POST:[NSString api_delete_path] parameters:[[ @{@"forum_topic_id" : forumtopicId}
                                                                      fillUserInfo]                        fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return:@"success"];
    }] logError] replayLazily];
}

- (RACSignal *)closeVoteWithFormtopicId:(NSString *)forumtopicId
{
    return [[[[[self rac_POST:[NSString api_close_vote_path] parameters:[[ @{@"forum_topic_id" : forumtopicId}
                                                                          fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return:@"success"];
    }] logError] replayLazily];
}

- (RACSignal *)updatePostWithForumtopicId:(NSString *)forumtopicId title:(NSString *)title content:(NSString *)content picUrls:(NSArray *)picUrls
{
    NSParameterAssert(forumtopicId);
    NSParameterAssert(title);
    NSParameterAssert(content);
    NSMutableDictionary *parameters = [@{
                                         @"forum_topic_id":forumtopicId,
                                         @"title":title,
                                         @"type":@"1",
                                         @"content":content
                                         }
                                       mutableCopy];
    if(picUrls) {
        [parameters setObject:picUrls.arrayToJson forKey:@"pic_urls"];
    }
    
    return [[[[[self rac_POST:[NSString api_update_path] parameters:[[parameters fillUserInfo]                      fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }        
        return [RACSignal return :value];
    }] logError] replayLazily];
}

@end
