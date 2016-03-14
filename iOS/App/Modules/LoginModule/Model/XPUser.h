//
//  XPUser.h
//  XPApp
//
//  Created by huangxinping on 15/11/15.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"
#import "XPLoginModel.h"


/**
 *  该模型用于持久化用户信息
 */
@interface XPUser : XPBaseModel

@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *accessToken;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *gender;
@property (nonatomic,strong) NSString *avatarUrl;
@property (nonatomic,assign) NSInteger point;
@property (nonatomic,strong) NSString * timestamp;
@property (nonatomic,assign) BOOL isBound;                            /**< 是否绑定房号0否1是 */
//XPHousehold
@property (nonatomic,strong) NSString *communityId;
@property (nonatomic,strong) NSString *communityTitle;
@property (nonatomic,strong) NSString *householdId;
@property (nonatomic,strong) NSString *room;
@property (nonatomic,strong) NSString *unit;
@property (nonatomic,strong) NSString *cityCode;

+ (XPUser *)turnData:(XPLoginModel *)model;
+ (void)launched;
+ (BOOL)isFirstLaunch;
+ (void)accessUserInfoInLoginModel;

@end
