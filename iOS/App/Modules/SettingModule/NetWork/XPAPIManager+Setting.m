//
//  XPAPIManager+Setting.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/12.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+Setting.h"
#import "NSString+XPAPISettingPath.h"
#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "XPAPIManager+Analysis.h"

@implementation XPAPIManager (Setting)

- (RACSignal *)sendSuggestionWithPhoneType:(NSString *)type content:(NSString *)content version:(NSInteger)version{
  
    NSMutableDictionary *parameters = [@{
                                         @"content":content,
                                         @"os_type":type,
                                         @"version_code":@(version)
                                         }
                                       mutableCopy];
    return [[[[[self rac_POST:[NSString api_feedback_path] parameters:[[parameters fillUserInfo]
                                                                       fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return :value];
    }] logError] replayLazily];
}

@end
