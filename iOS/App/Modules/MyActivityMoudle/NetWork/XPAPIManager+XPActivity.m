//
//  XPAPIManager+XPActivity.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/8.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "NSString+Activitypath.h"
#import "NSString+XPAPIPath_CreatePost.h"
#import "XPAPIManager+Analysis.h"
#import "XPAPIManager+XPActivity.h"
#import "XPDetailPostModel.h"
#import "XPTopicModel.h"
#import <XPKit.h>

@implementation XPAPIManager (XPActivity)

- (RACSignal *)getMyactivity
{
    return [[[[[self rac_GET:[NSString api_my_participation] parameters:[[ @{}
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
