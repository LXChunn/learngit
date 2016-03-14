//
//  XPLoginViewModel.m
//  XPApp
//
//  Created by huangxinping on 15/9/23.
//  Copyright © 2015年 iiseeuu.com. All rights reserved.
//

#import <XPKit/XPKit.h>

#import "NSString+XPValid.h"
#import "XPAPIManager+Login.h"
#import "XPLoginModel.h"
#import "XPLoginStorage.h"
#import "XPLoginViewModel.h"
#import <APService.h>

@interface XPLoginViewModel ()

@property (nonatomic, strong) RACSignal *loginSignal;
@property (nonatomic, strong, readwrite) XPLoginModel *model;
@property (nonatomic, strong, readwrite) RACCommand *comfirmCommand;
@property (nonatomic, strong, readwrite) RACCommand *vericationCodeCommand;
@property (nonatomic, strong, readwrite) RACCommand *userInfoCommand;

@end

@implementation XPLoginViewModel

#pragma mark - LifeCircle
- (instancetype)init
{
    if((self = [super init])) {
        self.autoLogin = NO;
    }
    return self;
}

#pragma mark - Getter & Setter
- (RACSignal *)phoneSignal
{
    if(!_phoneSignal) {
        _phoneSignal = [RACSignal combineLatest:@[RACObserve(self, phone)] reduce:^id (NSString *phone){
            return @([phone isPhone] || self.autoLogin);
        }];
    }
    
    return _phoneSignal;
}

- (RACSignal *)loginSignal
{
    if(!_loginSignal) {
        _loginSignal = [RACSignal combineLatest:@[RACObserve(self, phone), RACObserve(self, verificationCode), RACObserve(self, autoLogin)] reduce:^id (NSString *phone, NSString *verificationCode){
            return @(([phone isPhone] && verificationCode.length == 6) || self.autoLogin);
        }];
    }
    
    return _loginSignal;
}

- (RACCommand *)vericationCodeCommand
{
    if(!_vericationCodeCommand) {
        @weakify(self);
        _vericationCodeCommand = [[RACCommand alloc] initWithEnabled:self.phoneSignal signalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager vericationCodeWithPhone:self.phone];
        }];
        XPViewModelShortHand(_vericationCodeCommand)
    }
    
    return _vericationCodeCommand;
}

- (RACCommand *)userInfoCommand
{
    if(!_userInfoCommand) {
        @weakify(self);
        _userInfoCommand = [[RACCommand alloc] initWithEnabled:self.loginSignal signalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager userInfo];
        }];
        [[_userInfoCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            self.model = x;
            [APService setAlias:[NSString stringWithFormat:@"%@",self.model.accessToken] callbackSelector:nil object:nil];
        }];
        XPViewModelShortHand(_userInfoCommand)
    }
    return _userInfoCommand;
}

- (RACCommand *)comfirmCommand
{
    if(!_comfirmCommand) {
        @weakify(self);
        _comfirmCommand = [[RACCommand alloc] initWithEnabled:self.loginSignal signalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[self.apiManager loginWithPhone:self.phone verificationCode:self.verificationCode] flattenMap:^RACStream *(id value) {
                @strongify(self);
                return [[[self saveUserWithModel:value] ignoreValues] concat:[RACSignal return :value]];
            }];
        }];
        [[_comfirmCommand.executionSignals concat] subscribeNext:^(XPLoginModel * x) {
            @strongify(self);
            self.model = x;
            [APService setAlias:[NSString stringWithFormat:@"%@",x.accessToken] callbackSelector:nil object:nil];
        }];
        XPViewModelShortHand(_comfirmCommand)
    }
    return _comfirmCommand;
}

- (RACSignal *)saveUserWithModel:(XPLoginModel *)value
{
    return [RACSignal createSignal:^RACDisposable *(id < RACSubscriber > subscriber) {
        [XPLoginStorage storageWithUser:[[[XPUser alloc] init] tap:^(XPUser *x) {
            x.householdId = value.household.householdId;
            [XPLoginStorage storageWithUser:[XPUser turnData:value]];
            NSLog(@"-----------%@",[XPUser turnData:value]);
            NSLog(@"+++++++++++%@",[XPLoginStorage user]);
        }]];
        [subscriber sendNext:@YES];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
        }];
    }];
}

@end
