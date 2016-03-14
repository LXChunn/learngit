//
//  XPMessageDetailModel.h
//  XPApp
//
//  Created by jy on 16/1/9.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"

@interface XPMessageDetailModel : XPBaseModel
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, strong) NSString *type;               /**< 私信类型：1-我发送给对方的私信；2-对方发给我的私信
                                                             */
@end
