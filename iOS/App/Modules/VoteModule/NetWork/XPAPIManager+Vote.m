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
#import "XPVoteModel.h"

@implementation XPAPIManager (Vote)

-(RACSignal *)voteWithaccessToken:(NSString *)accessToken withtitle:(NSString *)title withcontent:(NSString *)content withtype:(NSString *)type withoptions:(NSArray *)options
{
    NSParameterAssert(content);
    NSParameterAssert(type);
    NSParameterAssert(title);
    NSParameterAssert(accessToken);
    NSMutableDictionary *parameters = [@{
                                         @"content":content,
                                         @"type":type,
                                         @"content":title,
                                         @"access_token":accessToken,
                                         }
                                       mutableCopy];
    if(options) {
        [parameters setObject:options forKey:@"options"];
    }
    return [[[[[self rac_POST:[NSString api_releasvote_path] parameters:[[parameters fillUserInfo]                      fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        
        return [RACSignal return :value];
    }] logError] replayLazily];


}

-(RACSignal *)voteWithaccessToken:(NSString *)accessToken withforumTopicId:(NSString *)forumTopicId
{
    return [[[[[self rac_POST:[NSString api_vote_path] parameters:[@{
                                                                      @"access_token":accessToken,
                                                                      @"forum_topic_id":forumTopicId,
                                                                           }
                                                                         fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [self rac_MappingForClass:[XPVoteModel class] dictionary:value];
    }] logError] replayLazily];

}

@end 
