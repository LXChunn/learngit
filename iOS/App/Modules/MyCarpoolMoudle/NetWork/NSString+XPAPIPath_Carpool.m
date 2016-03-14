//
//  NSString+XPAPIPath_Carpool.m
//  XPApp
//
//  Created by CaoShunQing on 16/2/23.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "NSString+XPAPIPath.h"
#import "NSString+XPAPIPath_Carpool.h"

@implementation NSString (XPAPIPath_Carpool)

+ (NSString *)api_my_carpoolings_path
{
    return [@"/api/v1/my_carpoolings" fillBaseAPIPath];
}

@end 
