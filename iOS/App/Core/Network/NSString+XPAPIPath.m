//  NSString+XPAPIPath.m
//  Huaban
//
//  Created by huangxinping on 4/24/15.
//  Copyright (c) 2015 iiseeuu.com. All rights reserved.
//

#import "NSString+XPAPIPath.h"
#import <XPKit/XPKit.h>

@implementation NSString (XPAPIPath)

- (NSString *)fillBaseAPIPath
{
    NSString *fillBuffer = [NSString stringWithFormat:@"%@%@", XPAPIBaseURL2, self];
    //    XPLog(@"URL全路径：%@", fillBuffer);
    return fillBuffer;
}

- (NSString *)fillBaseAPIPath2
{
//#if XP_API_TEST
//    NSString *fillBuffer = [NSString stringWithFormat:@"%@%@", XPAPIBaseURL, self];
//#else
    NSString *fillBuffer = [NSString stringWithFormat:@"%@%@", XPAPIBaseURL2, self];
//#endif
    //    XPLog(@"URL全路径：%@", fillBuffer);
    return fillBuffer;
}

@end
