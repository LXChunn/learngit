//
//  NSString+XPAPIPath_Vote.m
//  XPApp
//
//  Created by Mac OS on 15/12/31.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "NSString+XPAPIPath.h"
#import "NSString+XPAPIPath_Vote.h"

@implementation NSString (XPAPIPath_Vote)

+ (NSString *)api_vote_path
{
    return [@"/api/v1/forum_topic" fillBaseAPIPath];
}

+ (NSString *)api_releasvote_path
{
    return [@"/api/v1/forum_topic/create" fillBaseAPIPath];
}

+ (NSString *)api_from_topic_vote_path
{
    return [@"/api/v1/forum_topic/vote" fillBaseAPIPath];
}

+ (NSString *)api_forum_comments_path
{
    return [@"/api/v1/forum_comments" fillBaseAPIPath];
}

+ (NSString *)api_forum_comment_create_path
{
    return [@"/api/v1/forum_comment/create" fillBaseAPIPath];
}

@end
