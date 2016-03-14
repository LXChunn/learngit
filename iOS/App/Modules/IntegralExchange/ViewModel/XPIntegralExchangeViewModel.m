//
//  XPIntegralExchangeViewModel.m
//  XPApp
//
//  Created by CaoShunQing on 16/2/24.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPIntegralExchangeViewModel.h"
#import "XPAPIManager+IntegralExchange.h"

@interface XPIntegralExchangeViewModel ()
@property (nonatomic ,strong, readwrite)RACCommand *ExchangeCommand;
@property (nonatomic, strong, readwrite)RACCommand *RecordExchangeCommand;
@property (nonatomic, strong, readwrite)NSArray *listArray;
@property (nonatomic, assign, readwrite)BOOL isSuccess;

@end

@implementation XPIntegralExchangeViewModel

- (instancetype)init {
	if (self = [super init]) {
        self.isSuccess = NO;
	}
	return self;
}

- (RACCommand *)ExchangeCommand
{
    if(!_ExchangeCommand) {
        @weakify(self);
        _ExchangeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager MyPointsExchange:self.point];
        }];
        [[_ExchangeCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            if ([x isEqualToString:@"success"]) {
                self.isSuccess = YES;
            }
        }];
        XPViewModelShortHand(_ExchangeCommand)
    }
    return _ExchangeCommand;
}

- (RACCommand *)RecordExchangeCommand
{
    if (!_RecordExchangeCommand) {
        @weakify(self);
        _RecordExchangeCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager MyrecordsPointsExchange];
        }];
        [[_RecordExchangeCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            self.listArray = x;
        }];
        XPViewModelShortHand(_RecordExchangeCommand);
    }
    return _RecordExchangeCommand;
}
@end
