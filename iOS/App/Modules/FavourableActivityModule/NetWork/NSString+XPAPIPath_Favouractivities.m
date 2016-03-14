//
//  NSString+XPAPIPath_Favouractivities.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/18.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "NSString+XPAPIPath.h"
#import "NSString+XPAPIPath_Favouractivities.h"


@implementation NSString (XPAPIPath_Favouractivities)
+(NSString *)api_ccb_activities
{
    return [@"/api/v1/ccb_activities" fillBaseAPIPath];
}

@end 
