//
//  XPSecondHandViewModel.m
//  XPApp
//
//  Created by jy on 15/12/29.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+SecondHand.h"
#import "XPSecondHandItemsListModel.h"
#import "XPSecondHandViewModel.h"

@interface XPSecondHandViewModel ()
@property (nonatomic, strong, readwrite) RACCommand *secondHandReloadCommand;
@property (nonatomic, strong, readwrite) RACCommand *secondHandMoreCommand;
@property (nonatomic, strong, readwrite) NSArray *list;
@property (nonatomic, strong, readwrite) NSString *lastSecondHandItemId;
@property (nonatomic, assign, readwrite) BOOL isNoMoreDate;
@end

@implementation XPSecondHandViewModel

- (instancetype)init
{
    if(self = [super init]) {
        self.isNoMoreDate = NO;
    }
    return self;
}

- (RACCommand *)secondHandReloadCommand
{
    if(!_secondHandReloadCommand) {
        @weakify(self);
        _secondHandReloadCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager secondHandListWithType:self.type lastSecondHandItemId:nil];
        }];
        [[_secondHandReloadCommand.executionSignals concat] subscribeNext:^(NSArray * x) {
            @strongify(self);
            if(x.count > 0) {
                XPSecondHandItemsListModel *lastModel = [x lastObject];
                self.lastSecondHandItemId = lastModel.secondhandItemId;
            }
            self.list = x;
            if (x.count < 20) {
                self.isNoMoreDate = YES;
            }
        }];
        XPViewModelShortHand(_secondHandReloadCommand)
    }
    
    return _secondHandReloadCommand;
}

- (RACCommand *)secondHandMoreCommand
{
    if(!_secondHandMoreCommand) {
        @weakify(self);
        _secondHandMoreCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager secondHandListWithType:self.type lastSecondHandItemId:self.lastSecondHandItemId];
        }];
        [[_secondHandMoreCommand.executionSignals concat] subscribeNext:^(NSArray * x) {
            @strongify(self);
            if(x.count > 0) {
                XPSecondHandItemsListModel *lastModel = [x lastObject];
                self.lastSecondHandItemId = lastModel.secondhandItemId;
            }
            if (self.list) {
                self.list = [self.list arrayByAddingObjectsFromArray:x];
            }else{
                self.list = x;
            }
            if (x.count < 20) {
                self.isNoMoreDate = YES;
            }
        }];
        XPViewModelShortHand(_secondHandMoreCommand)
    }
    return _secondHandMoreCommand;
}

@end
