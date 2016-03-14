//
//  XPLoginModel.m
//  XPApp
//
//  Created by huangxinping on 15/9/25.
//  Copyright © 2015年 iiseeuu.com. All rights reserved.
//

#import "XPLoginModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation XPHousehold

@end

@implementation XPLoginModel

- (instancetype)init
{
    if((self = [super init])) {
        RAC(self, signIn) = [[RACObserve(self, userId) distinctUntilChanged] map:^id (id value) {
            return value ? @YES : @NO;
        }];
        RAC(self, timestamp) = [[RACObserve(self, signIn) distinctUntilChanged] map:^id (id value) {
            if([value boolValue]) {
                return [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            } else {
                return nil;
            }
        }];
        RAC(self, isBound) = [[RACObserve(self, household) distinctUntilChanged] map:^id (id value) {
            return value ? @YES : @NO;
        }];
    }
    return self;
}

- (XPHousehold *)household
{
    if (!_household) {
        _household = [[XPHousehold alloc] init];
    }
    return _household;
}

- (void)loginOut
{
    _signIn = NO;
    _timestamp = nil;
    _userId = nil;
    _accessToken = nil;
    _mobile = nil;
    _avatarUrl = nil;
    _gender = nil;
    _household = nil;
    _isBound = NO;
    _nickname = nil;
}

@end
