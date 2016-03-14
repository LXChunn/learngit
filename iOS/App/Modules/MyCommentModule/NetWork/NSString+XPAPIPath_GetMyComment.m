//
//  NSString+XPAPIPath_GetMyComment.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/8.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "NSString+XPAPIPath.h"
#import "NSString+XPAPIPath_GetMyComment.h"

@implementation NSString (XPAPIPath_GetMyComment)

+ (NSString *)api_my_comments
{
    return [@"/api/v1/my_comments" fillBaseAPIPath];
}

@end
