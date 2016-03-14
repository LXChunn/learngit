//
//  XPAPIManager+XPChangeUserIn.h
//  XPApp
//
//  Created by CaoShunQing on 16/1/7.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager.h"

@interface XPAPIManager (XPChangeUserIn)

- (RACSignal *)createPostWithAvatarUrl:(NSString *)url nickName:(NSString *)name gender:(NSInteger)gender;

- (RACSignal *)changeUserPhoneWithOldMobile:(NSString *)oldMobile oldMobileVeriCode:(NSString *)oldVeriCode newMobile :(NSString *)newMobile newMobileVeriCode:(NSString *)newVeriCode;

- (RACSignal *)getVerCodeWithPhone:(NSString *)phone;
@end
