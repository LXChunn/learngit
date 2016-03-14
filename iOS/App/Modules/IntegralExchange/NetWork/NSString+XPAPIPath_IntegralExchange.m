//
//  NSString+XPAPIPath_IntegralExchange.m
//  XPApp
//
//  Created by CaoShunQing on 16/2/24.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "NSString+XPAPIPath.h"
#import "NSString+XPAPIPath_IntegralExchange.h"


@implementation NSString (XPAPIPath_IntegralExchange)

+ (NSString *)api_Integral_Exchange
{
    return [@"/api/v1/points/exchange" fillBaseAPIPath];
}

+ (NSString *)api_points_exchange_records
{
    return [@"/api/v1/points/exchange_records" fillBaseAPIPath];
}

@end 
