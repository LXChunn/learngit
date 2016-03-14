//
//  NSString+XPAPIPath_SystemMessage.m
//  XPApp
//
//  Created by jy on 16/1/15.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "NSString+XPAPIPath.h"
#import "NSString+XPAPIPath_SystemMessage.h"


@implementation NSString (XPAPIPath_SystemMessage)

+ (NSString *)api_check_systemmessage_list_path
{
    return [@"/api/v1/system_messages" fillBaseAPIPath];
}

@end 
