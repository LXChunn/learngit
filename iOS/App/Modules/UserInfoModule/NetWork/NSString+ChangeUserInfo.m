//
//  NSString+ChangeUserInfo.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/6.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "NSString+ChangeUserInfo.h"
#import "NSString+XPAPIPath.h"
@implementation NSString (ChangeUserInfo)
+ (NSString *)api_updateuserinfo_path
{
    return [@"/api/v1/user_info/update" fillBaseAPIPath];
}

+ (NSString *)api_usermobile_path
{
    return [@"/api/v1/user_mobile/update" fillBaseAPIPath];
}

+ (NSString *)api_vercode_path
{
    return [@"/api/v1/verification_code" fillBaseAPIPath];
}
@end
