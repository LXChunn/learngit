//
//  UIResponder+Router.m
//  RespondChain
//
//  Created by xinpinghuang on 3/1/16.
//  Copyright © 2016 huangxinping. All rights reserved.
//

#import "UIResponder+Router.h"

@implementation UIResponder (Router)

- (void)routerEventWithType:(EventChatCellType)eventType userInfo:(NSDictionary *)userInfo {
    [[self nextResponder] routerEventWithType:eventType userInfo:userInfo];
}

@end
