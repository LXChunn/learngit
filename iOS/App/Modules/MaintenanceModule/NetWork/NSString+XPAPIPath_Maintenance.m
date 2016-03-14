//
//  NSString+XPAPIPath_Maintenance.m
//  XPApp
//
//  Created by iiseeuu on 15/12/23.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "NSString+XPAPIPath.h"
#import "NSString+XPAPIPath_Maintenance.h"
@implementation NSString (XPAPIPath_Maintenance)

+ (NSString *)api_maintenance_submit_path
{
    return [@"/api/v1/maintenance_order/submit" fillBaseAPIPath];
}

+ (NSString *)api_mymaintenance_path
{
    return [@"/api/v1/maintenance_orders" fillBaseAPIPath];
}

+ (NSString *)api_cancelmaintenance_path
{
    return [@"/api/v1/maintenance_order/cancel" fillBaseAPIPath];
}

+ (NSString *)api_confirmmaintenance_path
{
    return [@"/api/v1/maintenance_order/confirm" fillBaseAPIPath];
}

@end
