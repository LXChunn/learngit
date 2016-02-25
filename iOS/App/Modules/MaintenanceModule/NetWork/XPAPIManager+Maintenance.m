//
//  XPAPIManager+Maintenance.m
//  XPApp
//
//  Created by iiseeuu on 15/12/23.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "NSString+XPAPIPath_Maintenance.h"
#import "XPAPIManager+Analysis.h"
#import "XPAPIManager+Maintenance.h"
#import "XPMyMaintenanceModel.h"

@implementation XPAPIManager (Maintenance)

- (RACSignal *)maintenanceSubmitWithContent:(NSString *)content withType:(NSString *)type withPicUrls:(NSArray *)picUrls
{
    NSParameterAssert(content);
    NSParameterAssert(type);
    NSMutableDictionary *parameters = [@{@"content":content,@"type":type} mutableCopy];
    if(picUrls.count > 0)
    {
        [parameters setObject:picUrls forKey:@"pic_urls"];
    }
    return [[[[[self rac_POST:[NSString api_maintenance_submit_path] parameters:[[parameters fillUserInfo]                      fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            NSError * error = value;
            if (error.code == 100)
            {
                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    [subscriber sendNext:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                    return nil;
                }];
            }
            return [RACSignal error:value];
        }
        return nil;
    }] logError] replayLazily];
}

- (RACSignal *)myMaintenance
{
    return [[[[[self rac_GET:[NSString api_mymaintenance_path] parameters:[[ @{}
                                                  fillUserInfo]                        fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [self rac_MappingForClass:[XPMyMaintenanceModel class] array:value[@"maintenance_orders"]];
    }] logError] replayLazily];

}

@end
