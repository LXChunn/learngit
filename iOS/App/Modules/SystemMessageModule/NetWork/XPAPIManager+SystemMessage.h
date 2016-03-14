//
//  XPAPIManager+SystemMessage.h
//  XPApp
//
//  Created by jy on 16/1/15.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager.h"

@interface XPAPIManager (SystemMessage)

- (RACSignal *)unReadSystemMesageListWithLastSystemMessage:(NSString *)lastSystemMessage;

@end
