//
//  ViewControllerB.m
//  RespondChain
//
//  Created by xinpinghuang on 3/1/16.
//  Copyright © 2016 huangxinping. All rights reserved.
//

#import "ViewControllerB.h"
#import "UIResponder+Router.h"

@implementation ViewControllerB

- (IBAction)pushButtonTaped:(id)sender {
    [self routerEventWithType:EventChatCellHeadLongPressEvent userInfo:@{@"name": @"B"}];
}

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
