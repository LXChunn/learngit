//
//  NSString+XPAPI_ConvenienceStore.m
//  XPApp
//
//  Created by iiseeuu on 16/1/15.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "NSString+XPAPI_ConvenienceStore.h"
#import "NSString+XPAPIPath.h"

@implementation NSString (XPAPI_ConvenienceStore)

+ (NSString *)api_conveniencestore_path
{
    return [@"/api/v1/convenience_store" fillBaseAPIPath];
    
}

@end
