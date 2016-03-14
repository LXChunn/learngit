//
//  XPAPIManager+PrivateLetter.h
//  XPApp
//
//  Created by jy on 16/1/9.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager.h"

@interface XPAPIManager (PrivateLetter)

- (RACSignal *)checkUnreadMessage;

- (RACSignal *)checkUnreadSystemMessage;

- (RACSignal *)checkMessageDetailWithContactUserId:(NSString *)contactUserId lastMessageId:(NSString *)lastMessageId;

- (RACSignal *)messageBoxListWithLastTimestamp:(NSString *)lastTimestamp;

- (RACSignal *)sendMessageWithReceiverId:(NSString *)receiverId content:(NSString *)content;

@end
