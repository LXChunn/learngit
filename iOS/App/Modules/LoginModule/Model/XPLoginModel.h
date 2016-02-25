//
//  XPLoginModel.h
//  XPApp
//
//  Created by huangxinping on 15/9/25.
//  Copyright © 2015年 iiseeuu.com. All rights reserved.
//

#import "XPBaseModel.h"

@protocol XPHousehold <NSObject>
@end
@interface XPHousehold : XPBaseModel

@property NSString *communityId;

@property NSString *householdId;
@property NSString *room;
@property NSString *unit;

@end

@interface XPLoginModel : XPBaseModel

@property BOOL signIn;
@property NSString *timestamp;
@property NSString *userId;
@property NSString *accessToken;
@property NSString *mobile;
@property NSString *avatarUrl;
@property NSString *gender;
@property XPHousehold *household;
@property BOOL isBound;
@property NSString *nickname;

@end
