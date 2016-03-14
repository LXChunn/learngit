//
//  NSString+XPAPIPath_Getpost.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/8.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "NSString+XPAPIPath.h"
#import "NSString+XPAPIPath_Getpost.h"

@implementation NSString (XPAPIPath_Getpost)

+ (NSString *)api_my_forum_topics
{
    return [@"/api/v1/my_forum_topics" fillBaseAPIPath];
}

+ (NSString *)api_my_secondhand_items
{
    return [@"/api/v1/my_secondhand_items" fillBaseAPIPath];
}

+ (NSString *)api_my_other_post
{
    return [@"/api/v1/my_other_post" fillBaseAPIPath];
}

+ (NSString *)api_my_carpooling
{
    return [@"/api/v1/carpooling" fillBaseAPIPath];
}

@end
