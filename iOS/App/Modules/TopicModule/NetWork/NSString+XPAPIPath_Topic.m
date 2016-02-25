//
//  NSString+XPAPIPath_Topic.m
//  XPApp
//
//  Created by iiseeuu on 15/12/28.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "NSString+XPAPIPath_Topic.h"
#import "NSString+XPAPIPath.h"

@implementation NSString (XPAPIPath_Topic)

+ (NSString *)api_topic_path
{
    return [@"/api/v1/forum_topics" fillBaseAPIPath];
}

@end
