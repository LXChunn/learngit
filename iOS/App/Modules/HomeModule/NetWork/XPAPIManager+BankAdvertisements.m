//
//  XPAPIManager+BankAdvertisements.m
//  XPApp
//
//  Created by iiseeuu on 16/1/12.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+Analysis.h"
#import "XPAPIManager+BankAdvertisements.h"
#import "NSString+XPAPIPath_BankAdvertisements.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "NSDictionary+XPAPIUserInfo.h"
#import "XPAnnouncementModel.h"

@implementation XPAPIManager (BankAdvertisements)

- (RACSignal *)bankAdvertisementsList
{
    return [[[[[self rac_GET:[NSString api_bankadvertisements_path] parameters:[@{} fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [self rac_MappingForClass:[XPAnnouncementModel class] array:value[@"bank_advertisements"]];
    }] logError] replayLazily];
}

@end 
