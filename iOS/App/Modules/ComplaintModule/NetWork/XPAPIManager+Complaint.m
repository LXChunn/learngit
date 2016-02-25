//
//  XPAPIpath+UtilityBills.m
//  XPApp
//
//  Created by Mac OS on 15/12/21.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+Complaint.h"
#import "NSString+XPAPIPath.h"

@implementation NSString (XPAPIManager_Complaint)

+ (NSString *)api_complaint_path
{
    return [@"/api/v1/complaint/submit" fillBaseAPIPath];
}
+ (NSString *)api_listcomplaint_path
{
    return [@"/api/v1/complaints" fillBaseAPIPath];
}


@end
