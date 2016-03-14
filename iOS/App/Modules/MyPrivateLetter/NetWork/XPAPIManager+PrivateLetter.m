//
//  XPAPIManager+PrivateLetter.m
//  XPApp
//
//  Created by jy on 16/1/9.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "NSString+XPAPIPath_PrivateLetter.h"
#import "XPAPIManager+Analysis.h"
#import "XPAPIManager+PrivateLetter.h"
#import "XPMessageDetailModel.h"
#import "XPMessageListModel.h"

@implementation XPAPIManager (PrivateLetter)

- (RACSignal *)checkUnreadMessage
{
    return [[[[[self rac_GET:[NSString api_check_unread_messages_path]
                parameters  :[[@{}
                               fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return:[value objectForKey:@"unread_messages_count"]];
    }] logError] replayLazily];
}

- (RACSignal *)checkUnreadSystemMessage
{
    return [[[[[self rac_GET:[NSString api_check_unread_systemmessage_path]
                parameters  :[[@{}
                               fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return:[value objectForKey:@"unread_system_messages_count"]];
    }] logError] replayLazily];
}

- (RACSignal *)messageBoxListWithLastTimestamp:(NSString *)lastTimestamp
{
    NSMutableDictionary *dic = [@{}
                                mutableCopy];
    if(lastTimestamp.length > 0) {
        [dic setValue:lastTimestamp forKey:@"last_timestamp"];
    }
    
    return [[[[[self rac_GET:[NSString api_message_box_path] parameters:[[dic fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        
        return [self rac_MappingForClass:[XPMessageListModel class] array:[value objectForKey:@"message_box"]];
    }] logError] replayLazily];
}

- (RACSignal *)checkMessageDetailWithContactUserId:(NSString *)contactUserId lastMessageId:(NSString *)lastMessageId
{
    NSMutableDictionary *dic = [@{@"contact_user_id":contactUserId}
                                mutableCopy];
    if(lastMessageId.length > 0) {
        [dic setValue:lastMessageId forKey:@"message_id"];
    }
    
    return [[[[[self rac_GET:[NSString api_check_message_detail_path] parameters:[[dic fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        
        return [self rac_MappingForClass:[XPMessageDetailModel class] array:[value objectForKey:@"messages"]];
    }] logError] replayLazily];
}

- (RACSignal *)sendMessageWithReceiverId:(NSString *)receiverId content:(NSString *)content
{
    return [[[[[self rac_POST:[NSString api_sendmessage_path] parameters:
                [[@{@"receiver_id":receiverId,
                    @"content":content}
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
