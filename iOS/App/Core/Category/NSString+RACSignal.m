//
//  NSString+RACSignal.h
//  XPApp
//
//  Created by huangxinping on 15/11/13.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "NSString+RACSignal.h"

@implementation NSString (RACSignal)

- (RACSignal *)rac_lineSignal
{
    return [[RACSignal createSignal:^RACDisposable *(id < RACSubscriber > subscriber) {
        [self enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
            [subscriber sendNext:line];
        }];
        [subscriber sendCompleted];
        return nil;
    }] setNameWithFormat:@"[%@] -rac_line", self];
}

@end
