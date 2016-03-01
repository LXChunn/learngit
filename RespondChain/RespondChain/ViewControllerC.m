//
//  ViewControllerC.m
//  RespondChain
//
//  Created by xinpinghuang on 3/1/16.
//  Copyright © 2016 huangxinping. All rights reserved.
//

#import "ViewControllerC.h"
#import "UIResponder+Router.h"

@implementation ViewControllerC

//- (UIResponder*)nextResponder {
//    return self.navigationController.viewControllers[1];
//}

- (IBAction)pushButtonTaped:(id)sender {
    [self routerEventWithType:EventChatCellHeadLongPressEvent userInfo:@{@"name": @"C"}];
    NSLog(@"%@",self.nextResponder.class);
}
//
- (void)routerEventWithType:(EventChatCellType)eventType userInfo:(NSDictionary *)userInfo {
    switch (eventType) {
        case EventChatCellHeadLongPressEvent:
            NSLog(@"%@ = %@",self.class,userInfo);
            break;
            
        default:
            break;
    }
}

@end
