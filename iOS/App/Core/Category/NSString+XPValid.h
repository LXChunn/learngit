//
//  NSString+XPValid.h
//  XPApp
//
//  Created by huangxinping on 15/9/25.
//  Copyright © 2015年 iiseeuu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XPValid)

/**
 *  是否有效座机
 */
- (BOOL)isWorkPhone;

/**
 *  是否有效手机号
 */
- (BOOL)isPhone;

/**
 *  是否有效QQ
 */
- (BOOL)isQQ;

/**
 *  是否有效生日
 */
- (BOOL)isBirthday;

/**
 *  是否有效验证码
 */
- (BOOL)isCode;

/**
 *  是否有效意见反馈（也许会检测非法关键字等...）
 */
- (BOOL)isFeedback;

@end
