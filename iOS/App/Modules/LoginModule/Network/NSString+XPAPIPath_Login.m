//
//  NSString+XPAPIPath_Login.m
//  XPApp
//
//  Created by huangxinping on 15/9/23.
//  Copyright © 2015年 iiseeuu.com. All rights reserved.
//

#import "NSString+XPAPIPath.h"
#import "NSString+XPAPIPath_Login.h"

@implementation NSString (XPAPIPath_Login)

+ (NSString *)api_login_path
{
    return [@"/api/v1/user/login" fillBaseAPIPath];
}

+ (NSString *)api_user_info_path
{
    return [@"/api/v1/user/info" fillBaseAPIPath];
}

+ (NSString *)api_verication_code_path
{
    return [@"/api/v1/verification_code" fillBaseAPIPath];
}

@end
