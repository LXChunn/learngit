//
//  NSDictionary+XPAPIVerifyKey.m
//  XPApp
//
//  Created by huangxinping on 15/10/14.
//  Copyright © 2015年 iiseeuu.com. All rights reserved.
//

#import "NSDictionary+XPAPISignature.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "NSString+XPAPIPath.h"
#import <XPKit/XPKit.h>

@implementation NSDictionary (XPAPIVerifyKey)

- (NSDictionary *)fillVerifyKeyInfo
{
    printf("-------开始组装参数-------\n");
    XPLog(@"%@", self);
    NSMutableDictionary *buffer = [NSMutableDictionary dictionaryWithDictionary:self];
    { // for Unit Test
        NSDictionary *environment = [[NSProcessInfo processInfo] environment];
        NSString *injectBundle = environment[@"XCInjectBundle"];
        BOOL isRunningTests = [[injectBundle pathExtension] isEqualToString:@"xctest"];
        if(isRunningTests) {
            [buffer setObject:@(1449908478) forKey:@"timestamp"];
        } else {
            [buffer setObject:@((long)[NSDate date].timeIntervalSince1970) forKey:@"timestamp"];
#if XP_API_TEST
            [buffer setObject:@"1449908478" forKey:@"timestamp"];
#endif
        }
    }
    
#if XP_API_TEST
    NSString *signature = @"e70b4edb139c6c37533f8ad8d2b44ffd4884973a";
    [buffer setObject:signature forKey:@"signature"];
#else
    NSString *signature = [buffer signature];
    [buffer setObject:signature forKey:@"signature"];
#endif
    
    XPLog(@"%@", buffer);
    printf("-------结束组装参数-------\n");
    return buffer;
}

@end
