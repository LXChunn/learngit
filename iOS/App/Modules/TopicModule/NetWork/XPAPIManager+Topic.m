//
//  XPAPIManager+Topic.m
//  XPApp
//
//  Created by iiseeuu on 15/12/28.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+Topic.h"
#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "XPAPIManager+Analysis.h"
#import "NSString+XPAPIPath_Topic.h"
#import "XPTopicModel.h"

@implementation XPAPIManager (Topic)

-(RACSignal *)forumTopic
{
    NSLog(@"%@",[NSString api_topic_path]);
    return [[[[[self rac_GET:[NSString api_topic_path] parameters:[[ @{}
                                                                            fillUserInfo]                        fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [self rac_MappingForClass:[XPTopicModel class] array:value[@"forum_topics"]];
    }] logError] replayLazily];
}

@end
