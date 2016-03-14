//
//  NSString+XPAPIPath_PrivateLetter.h
//  XPApp
//
//  Created by jy on 16/1/9.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XPAPIPath_PrivateLetter)

+ (NSString *)api_check_unread_messages_path;

+ (NSString *)api_check_unread_systemmessage_path;

+ (NSString *)api_check_message_detail_path;

+ (NSString *)api_message_box_path;

+ (NSString *)api_sendmessage_path;
@end
