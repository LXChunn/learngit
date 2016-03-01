//
//  View3.m
//  RespondChain
//
//  Created by xinpinghuang on 3/1/16.
//  Copyright © 2016 huangxinping. All rights reserved.
//

#import "View3.h"
#import "UIResponder+Router.h"

@implementation View3

- (IBAction)sendButtonTaped:(id)sender {
    [self routerEventWithType:EventChatCellHeadLongPressEvent userInfo:@{@"name": @"C-3"}];
}

@end
