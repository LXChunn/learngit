//
//  XPAPIManager+EventDetail.m
//  XPApp
//
//  Created by jy on 16/1/9.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "NSString+XPAPIPath_EventDetail.h"
#import "XPAPIManager+Analysis.h"
#import "XPAPIManager+Analysis.h"
#import "XPAPIManager+EventDetail.h"
#import "XPDetailModel.h"
#import <XPKit.h>
@implementation XPAPIManager (EventDetail)

- (RACSignal *)eventDetailWithForumtopicid:(NSString *)forumtopicId;
{
    return [[[[[self rac_GET:[NSString api_event_detail_path] parameters:[[ @{@"forum_topic_id" : forumtopicId}
                                                                           fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        
        return [self rac_MappingForClass:[XPDetailModel class] dictionary:value];
    }] logError] replayLazily];
}

- (RACSignal *)joinEventWithForumtopicid:(NSString *)forumtopicId
{
    return [[[[[self rac_POST:[NSString api_join_event_path] parameters:
                [[@{@"forum_topic_id":forumtopicId}
                  fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return:@"success"];
    }] logError] replayLazily];
}

@end
