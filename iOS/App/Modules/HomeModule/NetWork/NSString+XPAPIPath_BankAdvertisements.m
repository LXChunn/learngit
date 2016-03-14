//
//  NSString+XPAPIPath_BankAdvertisements.m
//  XPApp
//
//  Created by iiseeuu on 16/1/12.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "NSString+XPAPIPath.h"
#import "NSString+XPAPIPath_BankAdvertisements.h"


@implementation NSString (XPAPIPath_BankAdvertisements)

+ (NSString *)api_bankadvertisements_path
{
     return [@"/api/v1/bank_advertisements" fillBaseAPIPath];
}

@end 
