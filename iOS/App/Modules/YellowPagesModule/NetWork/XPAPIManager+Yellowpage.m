//
//  XPAPIManager+Yellowpage.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/14.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+Analysis.h"
#import "XPAPIManager+Yellowpage.h"
#import "NSString+XPAPIPath_Yellowpage.h"
#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "XPYellowPageModel.h"

@implementation XPAPIManager (Yellowpage)

- (RACSignal *)getMyPage
{
    return [[[[[self rac_GET:[NSString api_yellowpage_path] parameters:[[ @{}
                                                                          fillUserInfo]                        fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [self rac_MappingForClass:[XPYellowPageModel class] array:value[@"yellow_pages"]];
    }] logError] replayLazily];
}



@end 
