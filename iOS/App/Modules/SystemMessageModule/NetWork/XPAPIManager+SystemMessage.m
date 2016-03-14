//
//  XPAPIManager+SystemMessage.m
//  XPApp
//
//  Created by jy on 16/1/15.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+Analysis.h"
#import "XPAPIManager+SystemMessage.h"
#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "NSString+XPAPIPath_SystemMessage.h"
#import "XPSystemMessageModel.h"

@implementation XPAPIManager (SystemMessage)

- (RACSignal *)unReadSystemMesageListWithLastSystemMessage:(NSString *)lastSystemMessage
{
    NSMutableDictionary *dic = [@{}
                                mutableCopy];
    if(lastSystemMessage.length > 0) {
        [dic setValue:lastSystemMessage forKey:@"last_system_message_id"];
    }
    return [[[[[self rac_GET:[NSString api_check_systemmessage_list_path] parameters:[[dic fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [self rac_MappingForClass:[XPSystemMessageModel class] array:[value objectForKey:@"system_messages"]];
    }] logError] replayLazily];
}

@end 
