//
//  NSString+XPValid.m
//  XPApp
//
//  Created by huangxinping on 15/9/25.
//  Copyright © 2015年 iiseeuu.com. All rights reserved.
//

#import "NSString+XPValid.h"
#import <XPKit/XPKit.h>

@implementation NSString (XPValid)

#pragma mark - Public API
- (BOOL)isWorkPhone
{
    return YES;
}

- (BOOL)isQQ
{
    if([self isPureNumber] && self.length > 5) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isBirthday
{
    return YES;
}

- (BOOL)isPhone
{
    return (self.length == 11 && [[self substringToIndex:1] isEqualToString:@"1"]);
}

- (BOOL)isCode
{
    return (self.length == 6 && [self isPureInt]);
}

- (BOOL)isFeedback
{
    return (self.length > 0);
}

#pragma mark - Private API
- (BOOL)isPureNumber
{
    return ([self isPureInt] || [self isPureFloat]);
}

- (BOOL)isPureInt
{
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    
    return ([scan scanInt:&val] && [scan isAtEnd]);
}

- (BOOL)isPureFloat
{
    NSScanner *scan = [NSScanner scannerWithString:self];
    float val;
    
    return ([scan scanFloat:&val] && [scan isAtEnd]);
}

@end
