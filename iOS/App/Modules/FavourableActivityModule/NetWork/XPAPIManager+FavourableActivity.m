//
//  XPAPIManager+FavourableActivity.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/18.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+Analysis.h"
#import "XPAPIManager+FavourableActivity.h"
#import "NSString+XPAPIPath_Favouractivities.h"
#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "XPCcbActivitiesModel.h"

@implementation XPAPIManager (FavourableActivity)
- (RACSignal *)getFavourableActivitys:(NSString *)lastCcbactivityId
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    if (lastCcbactivityId.length>0) {
        [parameter setObject:lastCcbactivityId forKey:@"last_ccb_activity_id"];
    }
    return [[[[[self rac_GET:[NSString api_ccb_activities] parameters:[[ parameter
                                                                         fillUserInfo]                        fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [self rac_MappingForClass:[XPCcbActivitiesModel class] array:value[@"ccb_activities"]];
    }] logError] replayLazily];

}

@end 
