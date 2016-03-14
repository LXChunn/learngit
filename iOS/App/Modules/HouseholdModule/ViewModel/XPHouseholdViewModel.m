//
//  XPHouseholdViewModel.m
//  XPApp
//
//  Created by xinpinghuang on 12/15/15.
//  Copyright 2015 ShareMerge. All rights reserved.
//

#import "XPAPIManager+Household.h"
#import "XPHouseholdViewModel.h"
#import <XPKit/XPKit.h>
#import "XPLoginStorage.h"

@interface XPHouseholdViewModel ()

@property (nonatomic, strong) RACSignal *verificationCodeSignal;
@property (nonatomic,strong,readwrite) XPLoginModel *model;

@end

@implementation XPHouseholdViewModel

- (instancetype)init
{
    if(self = [super init]) {
    }
    
    return self;
}

#pragma mark - Getter && Setter
- (RACSignal *)verificationCodeSignal
{
    if(!_verificationCodeSignal) {
        _verificationCodeSignal = [RACSignal combineLatest:@[RACObserve(self, verificationCode)] reduce:^id (NSString *verificationCode){
            return @([verificationCode length] == 10);
        }];
    }
    
    return _verificationCodeSignal;
}

- (RACCommand *)bindCommand
{
    if(!_bindCommand) {
        @weakify(self);
        _bindCommand = [[RACCommand alloc] initWithEnabled:self.verificationCodeSignal signalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[self.apiManager bindHouseholdWithHouseId:self.verificationCode] flattenMap:^RACStream *(id value) {
                @strongify(self);
                return [[[self saveUserWithModel:value] ignoreValues] concat:[RACSignal return:value]];
            }];
        }];
        [[_bindCommand.executionSignals concat] subscribeNext:^(XPLoginModel * x) {
            @strongify(self);
            self.model = x;
        }];
        XPViewModelShortHand(_bindCommand)
    }
    return _bindCommand;
}

- (RACSignal *)saveUserWithModel:(XPLoginModel *)value
{
    return [RACSignal createSignal:^RACDisposable *(id < RACSubscriber > subscriber) {
        [XPLoginStorage storageWithUser:[[[XPUser alloc] init] tap:^(XPUser *x) {
            [XPLoginStorage storageWithUser:[XPUser turnData:value]];
        }]];
        [subscriber sendNext:@YES];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
        }];
    }];
}

@end
