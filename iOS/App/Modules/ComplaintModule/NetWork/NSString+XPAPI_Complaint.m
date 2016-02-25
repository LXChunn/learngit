//
//  XPAPIManager+Announcement.m
//  XPApp
//
//  Created by iiseeuu on 15/12/18.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+Complaint.h"
#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "XPAPIManager+Analysis.h"
#import "XPAPIManager+Complaint.h"
#import "XPComplaintModel.h"


@implementation XPAPIManager (Complaint)

- (RACSignal *)maintenanceWithContent:(NSString *)content withPicUrls:(NSArray *)picUrls
{
    NSParameterAssert(content);
    NSMutableDictionary *parameters = [@{
                                         @"content":content,
                                        }
                                       mutableCopy];
    if(picUrls) {
        [parameters setObject:picUrls forKey:@"pic_urls"];
    }
    
    return [[[[[self rac_GET:[NSString api_complaint_path] parameters:[[parameters fillUserInfo]                      fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        
        return [RACSignal return :value];
    }] logError] replayLazily];
}

/*
 查询该用户所属房屋的物业投诉列表
 */
- (RACSignal *)listComplait{

    return [[[[[self rac_GET:[NSString api_listcomplaint_path] parameters:[[ @{}
                                                                        fillUserInfo]                        fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
    if([value isKindOfClass:[NSError class]]) {
        return [RACSignal error:value];
        }
        return [self rac_MappingForClass:[XPComplaintModel class] array:value[@"complaints"]];
}] logError] replayLazily];

}

@end
