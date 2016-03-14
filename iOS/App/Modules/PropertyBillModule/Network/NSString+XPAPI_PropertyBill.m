//
//  XPAPIpath+UtilityBills.m
//  XPApp
//
//  Created by Mac OS on 15/12/21.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "NSString+XPAPIPath.h"
#import "NSString+XPAPI_PropertyBill.h"

@implementation NSString (XPAPIpath_PropertyBill)

+ (NSString *)api_propertybill_path
{
    return [@"/api/v1/property_bills" fillBaseAPIPath];
}

+ (NSString *)api_billpayment_url_path
{
    return [@"/api/v1/bill_payment_url" fillBaseAPIPath];
}

+ (NSString *)api_billpayment_path
{
    return [@"/api/v1/bill_payment" fillBaseAPIPath];
}
@end
