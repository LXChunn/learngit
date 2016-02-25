//
//  XPSecondHandViewModel.m
//  XPApp
//
//  Created by jy on 15/12/29.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPSecondHandViewModel.h"
#import "XPAPIManager+SecondHand.h"

@interface XPSecondHandViewModel ()
@property (nonatomic, strong, readwrite) RACCommand *listCommand;
@property (nonatomic, strong, readwrite) NSArray *list;

@end

@implementation XPSecondHandViewModel

- (RACCommand *)listCommand
{
    if(!_listCommand) {
        @weakify(self);
        _listCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager secondHandListWithType:self.type lastSecondHandItemId:self.lastSecondHandItemId];
        }];
        [[_listCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            self.list = x;
        }];
        XPViewModelShortHand(_listCommand)
    }
    
    return _listCommand;
}

@end 
