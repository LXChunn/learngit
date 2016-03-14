//
//  NSString+XPAPIPath_CreatePost.m
//  XPApp
//
//  Created by iiseeuu on 15/12/30.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "NSString+XPAPIPath.h"
#import "NSString+XPAPIPath_CreatePost.h"

@implementation NSString (XPAPIPath_CreatePost)
/**
 *  发布（普通，活动和投票）帖子
 *
 *  @return
 */
+ (NSString *)api_createpost_path
{
    return [@"/api/v1/forum_topic/create" fillBaseAPIPath];
}

+ (NSString *)api_detailpost_path
{
    return [@"/api/v1/forum_topic" fillBaseAPIPath];
}

+ (NSString *)api_update_path
{
    return [@"/api/v1/forum_topic/update" fillBaseAPIPath];
}

+ (NSString *)api_delete_path
{
    return [@"/api/v1/forum_topic/delete" fillBaseAPIPath];
}

+ (NSString *)api_close_vote_path
{
    return [@"/api/v1/forum_topic/close_vote" fillBaseAPIPath];
}

@end
