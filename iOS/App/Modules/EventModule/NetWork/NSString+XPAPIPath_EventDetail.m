//
//  NSString+XPAPIPath_EventDetail.m
//  XPApp
//
//  Created by jy on 16/1/9.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "NSString+XPAPIPath.h"
#import "NSString+XPAPIPath_EventDetail.h"

@implementation NSString (XPAPIPath_EventDetail)

+ (NSString *)api_event_detail_path
{
    return [@"/api/v1/forum_topic" fillBaseAPIPath];
}

+ (NSString *)api_join_event_path
{
    return [@"/api/v1/forum_topic/join" fillBaseAPIPath];
}

@end
