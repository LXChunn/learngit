//
//  ViewController.m
//  RespondChain
//
//  Created by xinpinghuang on 3/1/16.
//  Copyright © 2016 huangxinping. All rights reserved.
//

#import "ViewControllerA.h"
#import "UIResponder+Router.h"

@interface ViewControllerA ()

@end

@implementation ViewControllerA

- (void)routerEventWithType:(EventChatCellType)eventType userInfo:(NSDictionary *)userInfo {
    switch (eventType) {
        case EventChatCellHeadLongPressEvent:
            NSLog(@"%@ - %@",self.class,userInfo);
            break;
            
        default:
            break;
    }
}

@end
