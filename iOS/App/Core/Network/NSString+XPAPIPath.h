//
//  NSString+XPAPIPath.h
//  Huaban
//
//  Created by huangxinping on 4/24/15.
//  Copyright (c) 2015 iiseeuu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XP_API_TEST 0
#define XP_API_PUBLIC_TEST 1

#if XP_API_TEST
#else
//#define XPAPIBaseURL @"http://112.4.10.20:9292"
//#define XPAPIBaseURL2 @"https://112.4.10.20:9292"
#endif

#if XP_API_PUBLIC_TEST
#define XPAPIBaseURL @"http://dragonbutler.memeyin.com"
#define XPAPIBaseURL2 @"https://dragonbutler.memeyin.com"
#else
#define XPAPIBaseURL @"http://192.168.0.101:12306"
#define XPAPIBaseURL2 @"https://192.168.0.101:12306"
#endif

@interface NSString (XPAPIPath)

/**
 *  @brief  填充API基路径
 *
 *  @return API全路径
 */
- (NSString *)fillBaseAPIPath;

/**
 *  填充HTTPS API基路径（跟上面的区别是使用了https）
 *
 *  @return API全路径
 */
- (NSString *)fillBaseAPIPath2;

@end
