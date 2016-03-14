//
//  XPActivitModel.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/7.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+XPActivity.h"
#import "XPActivitViewModel.h"

@interface XPActivitViewModel ()

@property (nonatomic, strong, readwrite) NSArray *souceArray;
@property (nonatomic, strong, readwrite) RACCommand *activtyCommand;
@end

@implementation XPActivitViewModel

- (RACCommand *)activtyCommand
{
    if(!_activtyCommand) {
        @weakify(self);
        _activtyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager getMyactivity];
        }];
        [[_activtyCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            self.souceArray = x;
        }];
        XPViewModelShortHand(_activtyCommand)
    }
    
    return _activtyCommand;
}

@end
