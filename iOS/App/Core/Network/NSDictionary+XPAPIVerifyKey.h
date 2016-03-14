//
//  NSDictionary+XPAPIVerifyKey.h
//  XPApp
//
//  Created by huangxinping on 15/10/14.
//  Copyright © 2015年 iiseeuu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (XPAPIVerifyKey)

/**
 *  通过现有参数获得签名
 *
 *  @return 填充过的请求参数
 */
- (NSDictionary *)fillVerifyKeyInfo;

@end
