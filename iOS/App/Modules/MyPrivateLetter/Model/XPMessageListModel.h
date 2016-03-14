//
//  XPMessageListModel.h
//  XPApp
//
//  Created by jy on 16/1/9.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAuthorModel.h"
#import "XPBaseModel.h"

@interface XPMessageListModel : XPBaseModel
@property (nonatomic, strong) XPAuthorModel *contact;
@property (nonatomic, strong) NSString *lastMessageContent;
@property (nonatomic, strong) NSString *lastMessageDate;
@property (nonatomic, assign) NSInteger unreadMessagesCount;

@end
