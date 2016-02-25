//
//  XPAPIManager+Household.m
//  XPApp
//
//  Created by xinpinghuang on 12/15/15.
//  Copyright 2015 ShareMerge. All rights reserved.
//

#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "NSString+XPAPIPath_Household.h"
#import "XPAPIManager+Analysis.h"
#import "XPAPIManager+Household.h"
#import "XPLoginModel.h"

@implementation XPAPIManager (Household)

- (RACSignal *)bindHouseholdWithHouseId:(NSString *)houseId
{
    NSParameterAssert(houseId.length == 10);
    return [[[[[self rac_POST:[NSString api_bind_house_hold_path] parameters:[[@{
                                                                                 @"verification_code" : houseId
                                                                                 }
                                                                               fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        
        return [self rac_MergeMappingForClass:[XPLoginModel class] dictionary:value];
    }] logError] replayLazily];
}

@end
