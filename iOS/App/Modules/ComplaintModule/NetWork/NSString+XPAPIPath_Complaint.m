//
//  NSString+XPAPIPath_Complaint.m
//  XPApp
//
//  Created by jy on 16/2/3.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "NSString+XPAPIPath.h"
#import "NSString+XPAPIPath_Complaint.h"


@implementation NSString (XPAPIPath_Complaint)

+ (NSString *)api_complaint_path
{
    return [@"/api/v1/complaint/submit" fillBaseAPIPath];
}

+ (NSString *)api_listcomplaint_path
{
    return [@"/api/v1/complaints" fillBaseAPIPath];
}

+ (NSString *)api_cancelcomplaint_path
{
    return [@"/api/v1/complaint/cancel" fillBaseAPIPath];
}

+ (NSString *)api_confirmcomplaint_path
{
    return [@"/api/v1/complaint/confirm" fillBaseAPIPath];
}


@end 
