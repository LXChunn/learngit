//
//  XPAPIManager+Login.h
//  XPApp
//
//  Created by huangxinping on 15/9/23.
//  Copyright © 2015年 iiseeuu.com. All rights reserved.
//

#import "XPAPIManager.h"

@interface XPAPIManager (Login)

/**
 *  发送验证码
 *
 *  @param phone 手机号
 *
 *  @return 信号
 */
- (RACSignal *)vericationCodeWithPhone:(NSString *)phone;

/**
 *  登录
 *
 *  @param phone    手机号
 *  @param verificationCode 验证码
 *
 *  @return 信号
 */
- (RACSignal *)loginWithPhone:(NSString *)phone verificationCode:(NSString *)verificationCode;

/**
 *  查询用户信息
 *
 *  @param userId 用户ID
 *
 *  @return 信号
 */
- (RACSignal *)userInfo;

@end
