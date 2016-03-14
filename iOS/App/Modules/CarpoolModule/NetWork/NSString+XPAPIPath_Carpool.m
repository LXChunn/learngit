//
//  NSString+XPAPIPath_Carpool.m
//  XPApp
//
//  Created by iiseeuu on 16/2/22.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "NSString+XPAPIPath.h"
#import "NSString+XPAPIPath_Carpool.h"


@implementation NSString (XPAPIPath_Carpool)
+ (NSString *)api_carpoolings_path
{
    return [@"/api/v1/carpoolings" fillBaseAPIPath];
}

+ (NSString *)api_carpooling_create_path
{
     return [@"/api/v1/carpooling/create" fillBaseAPIPath];
}

+ (NSString *)api_carpooling_delete_path
{
     return [@"/api/v1/carpooling/delete" fillBaseAPIPath];
}


@end 
