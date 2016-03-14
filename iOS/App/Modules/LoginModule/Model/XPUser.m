//
//  XPUser.m
//  XPApp
//
//  Created by huangxinping on 15/11/15.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPUser.h"
#import "XPLoginStorage.h"

@implementation XPUser

- (instancetype)init
{
    if(self = [super init]) {
        self.isBound = NO;
    }
    return self;
}

+ (XPUser *)turnData:(XPLoginModel *)model
{
    XPUser * user = [[XPUser alloc] init];
    user.userId = model.userId;
    user.accessToken = model.accessToken;
    user.mobile = model.mobile;
    user.nickname = model.nickname;
    user.gender = model.gender;
    user.avatarUrl = model.avatarUrl;
    user.timestamp = model.timestamp;
    user.point = model.point;
    user.isBound = model.isBound;
    user.communityId = model.household.communityId;
    user.communityTitle = model.household.communityTitle;
    user.householdId = model.household.householdId;
    user.room = model.household.room;
    user.unit = model.household.unit;
    user.cityCode = model.household.cityCode;
    return user;
}

+ (void)launched
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"FirstLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isFirstLaunch
{
    NSString * first = [[NSUserDefaults standardUserDefaults] objectForKey:@"FirstLaunch"];
    return first ? NO : YES;
}

+ (void)accessUserInfoInLoginModel
{
    XPUser * user = [XPLoginStorage user];
    [XPLoginModel singleton].userId = user.userId;
    [XPLoginModel singleton].accessToken = user.accessToken;
    [XPLoginModel singleton].point = user.point;
    [XPLoginModel singleton].mobile = user.mobile;
    [XPLoginModel singleton].avatarUrl = user.avatarUrl;
    [XPLoginModel singleton].gender = user.gender;
    [XPLoginModel singleton].timestamp = user.timestamp;
    [XPLoginModel singleton].nickname = user.nickname;
    [XPLoginModel singleton].isBound = user.isBound;
    [XPLoginModel singleton].household.communityId = user.communityId;
    [XPLoginModel singleton].household.communityTitle = user.communityTitle;
    [XPLoginModel singleton].household.householdId = user.householdId;
    [XPLoginModel singleton].household.room = user.room;
    [XPLoginModel singleton].household.unit = user.unit;
    [XPLoginModel singleton].household.cityCode = user.cityCode;
}


@end
