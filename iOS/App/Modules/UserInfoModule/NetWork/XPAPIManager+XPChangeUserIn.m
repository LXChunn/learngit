//
//  XPAPIManager+XPChangeUserIn.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/7.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "NSString+ChangeUserInfo.h"
#import "NSString+XPAPIPath_CreatePost.h"
#import "XPAPIManager+Analysis.h"
#import "XPAPIManager+CreatePost.h"
#import "XPAPIManager+XPChangeUserIn.h"
#import "XPDetailPostModel.h"
#import "NSString+ChangeUserInfo.h"
#import "XPLoginModel.h"

@implementation XPAPIManager (XPChangeUserIn)

- (RACSignal *)createPostWithAvatarUrl:(NSString *)url nickName:(NSString *)name gender:(NSInteger)gender;
{
    NSMutableDictionary *parameters = [@{
                                         @"avatar_url":url,
                                         @"nickname":name,
                                         @"gender":@(gender)
                                         }
                                       mutableCopy];
    return [[[[[self rac_POST:[NSString api_updateuserinfo_path] parameters:[[parameters fillUserInfo]                      fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [RACSignal return:value];
    }] logError] replayLazily];
}

- (RACSignal *)changeUserPhoneWithOldMobile:(NSString *)oldMobile oldMobileVeriCode:(NSString *)oldVeriCode newMobile :(NSString *)newMobile newMobileVeriCode:(NSString *)newVeriCode
{
    NSMutableDictionary *parameters =[@{@"old_mobile":oldMobile,
                                         @"old_mobile_vericode":oldVeriCode,
                                         @"new_mobile":newMobile,
                                         @"new_mobile_vericode":newVeriCode
                                         } mutableCopy];
    return [[[[[self rac_POST:[NSString api_usermobile_path] parameters:[[parameters fillUserInfo]                      fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        return [self rac_MergeMappingForClass:[XPLoginModel class] dictionary:value];;
    }] logError] replayLazily];
}

- (RACSignal *)getVerCodeWithPhone:(NSString *)phone
{
    return [[[[[self rac_POST:[NSString api_vercode_path] parameters:[[@{@"mobile":phone} fillUserInfo]                      fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
       return [RACSignal return:value];
    }] logError] replayLazily];
}
@end
