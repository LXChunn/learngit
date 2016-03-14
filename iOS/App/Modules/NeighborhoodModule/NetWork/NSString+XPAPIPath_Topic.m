//
//  NSString+XPAPIPath_Topic.m
//  XPApp
//
//  Created by iiseeuu on 15/12/30.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "NSString+XPAPIPath.h"
#import "NSString+XPAPIPath_Topic.h"

@implementation NSString (XPAPIPath_Topic)

+ (NSString *)api_topic_path
{
    return [@"/api/v1/forum_topics" fillBaseAPIPath];
}

+ (NSString *)api_my_participation_path
{
    return [@"/api/v1/my_participation" fillBaseAPIPath];
}

@end
