//
//  XPAPIManager+IntegralExchange.m
//  XPApp
//
//  Created by CaoShunQing on 16/2/24.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+Analysis.h"
#import "XPAPIManager+IntegralExchange.h"
#import "NSString+XPAPIPath_IntegralExchange.h"
#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "XPExchangeRecordModel.h"

@implementation XPAPIManager (IntegralExchange)

- (RACSignal *)MyPointsExchange:(NSInteger)point
{
    
    return [[[[[self rac_POST:[NSString api_Integral_Exchange] parameters:
                [[@{@"point":@(point)} fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return:@"success"];
    }] logError]replayLazily];
}

- (RACSignal *)MyrecordsPointsExchange
{
    return [[[[[self rac_GET:[NSString api_points_exchange_records] parameters:[[@{} fillUserInfo]fillVerifyKeyInfo]] map:^id(id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if ([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [self rac_MappingForClass:[XPExchangeRecordModel class] array:value[@"records"]];
    }]logError ]replayLazily];
}

@end
