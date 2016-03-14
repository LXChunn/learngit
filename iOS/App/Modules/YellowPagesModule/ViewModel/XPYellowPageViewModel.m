//
//  XPYellowPageViewModel.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/14.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPYellowPageViewModel.h"
#import "XPAPIManager+Yellowpage.h"
#import "XPYellowPageModel.h"

@interface XPYellowPageViewModel()
@property (nonatomic,strong,readwrite)RACCommand *yellowPageCommand;
@property (nonatomic,strong,readwrite)NSMutableArray *pageArray;
@end

@implementation XPYellowPageViewModel

- (RACCommand *)yellowPageCommand
{
    if(!_yellowPageCommand) {
        @weakify(self);
        _yellowPageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager getMyPage];
        }];
        [[_yellowPageCommand.executionSignals concat] subscribeNext:^(NSMutableArray *x) {
            @strongify(self);
            self.pageArray = x;
        }];
        XPViewModelShortHand(_yellowPageCommand)
    }
    return _yellowPageCommand;
}

@end
