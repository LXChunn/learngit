//
//  NSString+XPAPIPath_YellowPage.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/14.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "NSString+XPAPIPath.h"
#import "NSString+XPAPIPath_YellowPage.h"


@implementation NSString (XPAPIPath_YellowPage)

+ (NSString *)api_yellowpage_path
{
    return [@"/api/v1/yellow_pages" fillBaseAPIPath];
}
@end 
