//
//  NSString+XPAPISettingPath.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/12.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "NSString+XPAPISettingPath.h"
#import "NSString+XPAPIPath.h"

@implementation NSString (XPAPISettingPath)

+ (NSString *)api_feedback_path
{
    return [@"/api/v1/feedback" fillBaseAPIPath];
}

@end
