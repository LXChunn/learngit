//
//  XPAPIManager+Login.m
//  XPApp
//
//  Created by huangxinping on 15/9/23.
//  Copyright © 2015年 iiseeuu.com. All rights reserved.
//

#import "NSDictionary+XPAPIVerifyKey.h"
#import "NSString+XPAPIPath_Login.h"
#import "XPAPIManager+Analysis.h"
#import "XPAPIManager+Login.h"
#import "XPLoginModel.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "NSDictionary+XPAPIUserInfo.h"
#import <XPKit/XPKit.h>

@implementation XPAPIManager (Login)

- (RACSignal *)loginWithPhone:(NSString *)phone verificationCode:(NSString *)verificationCode
{
    NSParameterAssert(phone);
    NSParameterAssert(verificationCode);
    return [[[[[self rac_POST:[NSString api_login_path] parameters:[@{@"mobile":phone,@"verification_code":verificationCode} fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        
        return [self rac_MergeMappingForClass:[XPLoginModel class] dictionary:value];
    }] logError] replayLazily];
}

- (RACSignal *)userInfo
{
    return [[[[[self rac_GET:[NSString api_user_info_path] parameters:[[@{} fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        
        return [self rac_MergeMappingForClass:[XPLoginModel class] dictionary:value[@"user_info"]];
    }] logError] replayLazily];
}

- (RACSignal *)vericationCodeWithPhone:(NSString *)phone
{
    NSParameterAssert(phone);
    return [[[[[self rac_POST:[NSString api_verication_code_path] parameters:[@{
                                                                               @"mobile":phone
                                                                               }
                                                                             fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        
        return [RACSignal return :value];
        //        // 到此处时，本应是验证码获取成功，但是可以将信号转换为error信号以便通过toast有提示!
        //        NSError *error = [NSError errorWithDomain:kXPAPIErrorDomain code:500 userInfo:@{NSLocalizedDescriptionKey:@"请注意查收短信"}];
        //        return [RACSignal error:error];
    }] logError] replayLazily];
}

@end
