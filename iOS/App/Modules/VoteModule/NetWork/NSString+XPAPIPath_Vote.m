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

+(NSString *)api_vote_path
{
    return [@"/api/v1/forum_topic" fillBaseAPIPath];
}
+(NSString *)api_releasvote_path
{
    return [@"/api/v1/forum_topic/create" fillBaseAPIPath];
}

@end 
