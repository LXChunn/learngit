//
//  XPUser.m
//  XPApp
//
//  Created by huangxinping on 15/11/15.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPUser.h"

@implementation XPUser
- (void)setUserId:(NSString *)userId
{
    [[NSUserDefaults standardUserDefaults]setObject:userId forKey:@"UserId"];
}

- (NSString *)getUserId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"];
}

- (void)setAccessToken:(NSString *)accessToken
{
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"AccessToken"];
}

- (NSString *)getAccessToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"AccessToken"];
}

@end
