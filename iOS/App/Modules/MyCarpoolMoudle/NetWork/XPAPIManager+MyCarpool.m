//
//  XPAPIManager+Carpool.m
//  XPApp
//
//  Created by CaoShunQing on 16/2/23.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+Analysis.h"
#import "XPAPIManager+Carpool.h"
#import "NSString+XPAPIPath_Carpool.h"
#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "XPMyCarpoolModel.h"

@implementation XPAPIManager (MyCarpool)

- (RACSignal *)getMyCarpool:(NSString *)lastCarpoolItemid
{
    NSDictionary *dic = [@{}
                         mutableCopy];
    if(lastCarpoolItemid.length > 0) {
        [dic setValue:lastCarpoolItemid forKey:@"carpooling_item_id"];
    }
    
    return [[[[[self rac_GET:[NSString api_my_carpoolings_path] parameters:[[dic
                                                                          fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        
        return [self rac_MappingForClass:[XPMyCarpoolModel class] array:value[@"carpoolings"]];
    }] logError] replayLazily];
}

@end 
