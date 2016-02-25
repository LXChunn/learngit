//
//  NSDictionary+XPAPIUserInfo.m
//  XPApp
//
//  Created by xinpinghuang on 12/15/15.
//  Copyright © 2015 ShareMerge. All rights reserved.
//

#import "NSDictionary+XPAPIUserInfo.h"
#import "XPLoginModel.h"
#import <XPKit/XPKit.h>

@implementation NSDictionary (XPAPIUserInfo)

- (NSDictionary *)fillUserInfo
{
    printf("-------开始组装参数-------\n");
    XPLog(@"%@", self);
    NSMutableDictionary *buffer = [NSMutableDictionary dictionaryWithDictionary:self];
    if([XPLoginModel singleton].accessToken) {
        [buffer setObject:[XPLoginModel singleton].accessToken forKey:@"access_token"];
    } else { // 填写一个假的
        [buffer setObject:@"923ew8uiweur923eu773ucnv" forKey:@"access_token"];
    }
    XPLog(@"%@", buffer);
    printf("-------结束组装参数-------\n");
    return buffer;
}

@end
