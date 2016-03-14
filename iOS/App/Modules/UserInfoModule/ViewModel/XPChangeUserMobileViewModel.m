//
//  XPChangeUserMobileViewModel.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/15.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPChangeUserMobileViewModel.h"
#import "XPAPIManager+XPChangeUserIn.h"
#import "XPLoginStorage.h"

@interface XPChangeUserMobileViewModel ()
@property (nonatomic,strong,readwrite)RACCommand *userNewPhoneCommand;
@property (nonatomic,strong,readwrite)RACCommand *verFicationCodeCommand;
@property (nonatomic,assign,readwrite) BOOL isChangeSuccess;
@property (nonatomic,assign,readwrite) BOOL isReceiveCodeSuccess;
@property (nonatomic,strong,readwrite) XPLoginModel *model;
@end

@implementation XPChangeUserMobileViewModel

- (instancetype)init {
	if (self = [super init]) {
        self.oldVerificationCode = nil;
        self.oldPhone = nil;
        self.nowVerificationCode = nil;
        self.nowPhone = nil;
	}
	return self;
}

- (RACCommand *)userNewPhoneCommand
{
    if(!_userNewPhoneCommand) {
        @weakify(self);
        _userNewPhoneCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[self.apiManager changeUserPhoneWithOldMobile:self.oldPhone oldMobileVeriCode:self.oldVerificationCode newMobile:self.nowPhone newMobileVeriCode:self.nowVerificationCode] flattenMap:^RACStream *(id value) {
                @strongify(self);
                return [[[self saveUserWithModel:value] ignoreValues] concat:[RACSignal return :value]];
            }];
        }];
        [[[_userNewPhoneCommand executionSignals] concat] subscribeNext:^(XPLoginModel * x) {
            self.model = x;
        }];
        XPViewModelShortHand(_userNewPhoneCommand)
    }
    return _userNewPhoneCommand;
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

- (RACCommand *)verFicationCodeCommand
{
    if(!_verFicationCodeCommand) {
        @weakify(self);
        _verFicationCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager getVerCodeWithPhone:self.nowPhone];
        }];
        [[[_verFicationCodeCommand executionSignals] concat] subscribeNext:^(id x) {
            self.isReceiveCodeSuccess = YES;
        }];
        XPViewModelShortHand(_verFicationCodeCommand)
    }
    return _verFicationCodeCommand;
}
@end 
