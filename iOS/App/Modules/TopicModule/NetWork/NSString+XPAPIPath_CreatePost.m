//
//  NSString+XPAPIPath_CreatePost.m
//  XPApp
//
//  Created by iiseeuu on 15/12/30.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "NSString+XPAPIPath_CreatePost.h"
#import "NSString+XPAPIPath.h"

@implementation NSString (XPAPIPath_CreatePost)

+ (NSString *)api_createpost_path
{
    return [@"/api/v1/forum_topic/create" fillBaseAPIPath];
}

+ (NSString *)api_detailpost_path
{
    return [@"/api/v1/forum_topic" fillBaseAPIPath];
}

@end
