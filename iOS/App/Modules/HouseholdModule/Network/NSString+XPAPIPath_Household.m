//
//  NSString+XPAPIPath_Household.m
//  XPApp
//
//  Created by xinpinghuang on 12/15/15.
//  Copyright 2015 ShareMerge. All rights reserved.
//

#import "NSString+XPAPIPath.h"
#import "NSString+XPAPIPath_Household.h"

@implementation NSString (XPAPIPath_Household)

+ (NSString *)api_bind_house_hold_path
{
    return [@"/api/v1/household/bind" fillBaseAPIPath];
}

@end
