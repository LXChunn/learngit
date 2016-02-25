//
//  XPHouseholdViewModel.m
//  XPApp
//
//  Created by xinpinghuang on 12/15/15.
//  Copyright 2015 ShareMerge. All rights reserved.
//

#import "XPHouseholdViewModel.h"
#import "XPAPIManager+Household.h"
#import <XPKit/XPKit.h>

@interface XPHouseholdViewModel ()

@property (nonatomic, strong) RACSignal *verificationCodeSignal;


@end

@implementation XPHouseholdViewModel

- (instancetype)init {
	if (self = [super init]) {

	}
	return self;
}

#pragma mark - Getter && Setter
- (RACSignal*)verificationCodeSignal {
    if(!_verificationCodeSignal) {
        _verificationCodeSignal = [RACSignal combineLatest:@[RACObserve(self, verificationCode)] reduce:^id (NSString *verificationCode){
            return @([verificationCode length] == 10);
        }];
    }
    
    return _verificationCodeSignal;
}


- (RACCommand*)bindCommand {
    if (!_bindCommand) {
        @weakify(self);
        _bindCommand = [[RACCommand alloc] initWithEnabled:self.verificationCodeSignal signalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager bindHouseholdWithHouseId:self.verificationCode];
        }];
        [[_bindCommand.executionSignals concat] subscribeNext:^(id x) {
            XPLog(@"x");
        }];
        XPViewModelShortHand(_bindCommand)
    }
    return _bindCommand;
}

@end 
