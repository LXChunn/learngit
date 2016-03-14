//
//  XPAPIManager+Carpool.m
//  XPApp
//
//  Created by iiseeuu on 16/2/22.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+Analysis.h"
#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "XPAPIManager+Carpool.h"
#import "NSString+XPAPIPath_Carpool.h"
#import "XPCarpoolModel.h"
#import <XPKit.h>
@implementation XPAPIManager (Carpool)

- (RACSignal *)carpoolListWithLastCarpoolingItemId:(NSString *)lastCarpoolingItemId
{
    
    NSDictionary *dic = [@{}
                         mutableCopy];
    if(lastCarpoolingItemId.length > 0) {
        [dic setValue:lastCarpoolingItemId forKey:@"carpooling_item_id"];
    }
    
    return [[[[[self rac_GET:[NSString api_carpoolings_path] parameters:[[dic
                                                                           fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        
        return [self rac_MappingForClass:[XPCarpoolModel class] array:value[@"carpoolings"]];
    }] logError] replayLazily];
    
}


//发布业主拼车
- (RACSignal *)carpoolingCreateWithStartPoint:(NSString *)startPoint withEndPoint:(NSString *)endPoint withTime:(NSString *)startTiem withRemark:(NSString *)remark withMobile:(NSString *)mobile
{
    NSParameterAssert(startPoint);
    NSParameterAssert(endPoint);
    NSParameterAssert(startTiem);
    NSParameterAssert(mobile);
    
    NSMutableDictionary *parameters = [@{@"start_point":startPoint, @"end_point":endPoint,@"time":startTiem,@"mobile":mobile}
                                       mutableCopy];
    if (remark.length > 0) {
        [parameters setObject:remark forKey:@"remark"];
    }
    
    return [[[[[self rac_POST:[NSString api_carpooling_create_path] parameters:[[parameters fillUserInfo]                      fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return:value];
    }] logError] replayLazily];
    
}


- (RACSignal *)deleteWithcarpoolCarpoolingItemId:(NSString *)carpoolingItemId
{
    return [[[[[self rac_POST:[NSString api_carpooling_delete_path] parameters:[[ @{@"carpooling_item_id" : carpoolingItemId}
                                                                      fillUserInfo]                        fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return:@"success"];
    }] logError] replayLazily];
}




@end 
