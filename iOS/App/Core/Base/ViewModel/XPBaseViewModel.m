//
//  XPBaseViewModel.m
//  Huaban
//
//  Created by huangxinping on 4/21/15.
//  Copyright (c) 2015 iiseeuu.com. All rights reserved.
//

#import "XPBaseViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <XPKit/XPKit.h>

@implementation XPBaseViewModel

- (id)init
{
    if((self = [super init])) {
        [self.didBecomeActiveSignal
         subscribeNext:^(id x) {
             //             XPLogVerbose(@"%@ Active!", [self className]);
         }];
        [self.didBecomeInactiveSignal
         subscribeNext:^(id x) {
             //             XPLogVerbose(@"%@ Inactive!", [self className]);
         }];
        self.apiManager = [[XPAPIManager alloc] init];
    }
    return self;
}

- (void)bindModel:(XPBaseModel *)model
{
    XPLogWarn(@"It's implement transfer sub class.");
}

@end
