//
//  XPUser.h
//  XPApp
//
//  Created by huangxinping on 15/11/15.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"

/**
 *  该模型用于持久化用户信息
 */
@interface XPUser : XPBaseModel

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *accessToken;


- (NSString *)getAccessToken;
- (NSString *)getUserId;
@end
