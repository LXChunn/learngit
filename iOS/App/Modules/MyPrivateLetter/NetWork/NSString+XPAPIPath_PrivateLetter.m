//
//  NSString+XPAPIPath_PrivateLetter.m
//  XPApp
//
//  Created by jy on 16/1/9.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "NSString+XPAPIPath.h"
#import "NSString+XPAPIPath_PrivateLetter.h"

@implementation NSString (XPAPIPath_PrivateLetter)

+ (NSString *)api_check_unread_messages_path
{
    return [@"/api/v1/unread_messages" fillBaseAPIPath];
}

+ (NSString *)api_check_unread_systemmessage_path
{
    return [@"/api/v1/unread_system_messages" fillBaseAPIPath];
}

+ (NSString *)api_check_message_detail_path
{
    return [@"/api/v1/messages" fillBaseAPIPath];
}

+ (NSString *)api_message_box_path
{
    return [@"/api/v1/message_box" fillBaseAPIPath];
}

+ (NSString *)api_sendmessage_path
{
    return [@"/api/v1/message/create" fillBaseAPIPath];
}

@end
