//
//  XPSystemMessageModel.h
//  XPApp
//
//  Created by jy on 16/1/15.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"


@interface XPSystemMessageModel : XPBaseModel

@property (nonatomic,strong) NSString *systemMessageId;
@property (nonatomic,strong) NSString *createdAt;
@property (nonatomic,strong) NSString *content;

@end
