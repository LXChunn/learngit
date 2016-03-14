//
//  XPAPIManager+Complaint.m
//  XPApp
//
//  Created by jy on 16/2/3.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "NSArray+XPKit.h"
#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "XPAPIManager+Analysis.h"
#import "XPAPIManager+Complaint.h"
#import "NSString+XPAPIPath_Complaint.h"
#import "XPComplaintModel.h"

@implementation XPAPIManager (Complaint)

// Oops, it's example! so you can remove this function.
- (RACSignal *)maintenanceWithContent:(NSString *)content withPicUrls:(NSArray *)picUrls
{
    NSParameterAssert(content);
    NSMutableDictionary *parameters = [@{
                                         @"content":content,
                                         }
                                       mutableCopy];
    if(picUrls.count > 0) {
        [parameters setObject:picUrls.arrayToJson forKey:@"pic_urls"];
    }
    
    return [[[[[self rac_POST:[NSString api_complaint_path] parameters:[[parameters fillUserInfo]                      fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return:value];
    }] logError] replayLazily];
}

/*
 查询该用户所属房屋的物业投诉列表
 */
- (RACSignal *)listComplaitWithComplaintId:(NSString *)complaintId
{
    NSDictionary *dic = [@{}
                         mutableCopy];
    if(complaintId.length > 0) {
        [dic setValue:complaintId forKey:@"complaint_id"];
    }
    
    return [[[[[self rac_GET:[NSString api_listcomplaint_path] parameters:[[ dic
                                                                            fillUserInfo]                        fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        
        return [self rac_MappingForClass:[XPComplaintModel class] array:value[@"complaints"]];
    }] logError] replayLazily];
}

- (RACSignal *)cancelComplaintWithId:(NSString *)complaintId
{
    return [[[[[self rac_POST:[NSString api_cancelcomplaint_path] parameters:
                [[@{@"complaint_id":complaintId}
                  fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return:@"success"];
    }] logError] replayLazily];
}

- (RACSignal *)confirmComplaintWithId:(NSString *)complaintId
{
    return [[[[[self rac_POST:[NSString api_confirmcomplaint_path] parameters:
                [[@{@"complaint_id":complaintId}
                  fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return:@"success"];
    }] logError] replayLazily];
}


@end 
