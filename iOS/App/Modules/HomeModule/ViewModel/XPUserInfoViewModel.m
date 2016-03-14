//
//  XPUserInfoViewModel.m
//  XPApp
//
//  Created by jy on 15/12/31.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+Login.h"
#import "XPUserInfoViewModel.h"
#import "XPAPIManager+BankAdvertisements.h"
#import "XPLoginStorage.h"


@interface XPUserInfoViewModel ()
@property (nonatomic, strong, readwrite) XPLoginModel *model;
@property (nonatomic, strong, readwrite) RACCommand *userInfoCommand;
@property (nonatomic, strong, readwrite) NSArray *list;
@property (nonatomic, strong, readwrite) RACCommand *listCommand;

@end

@implementation XPUserInfoViewModel

- (RACCommand *)userInfoCommand
{
    if(!_userInfoCommand) {
        @weakify(self);
        _userInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [[self.apiManager userInfo] flattenMap:^RACStream *(id value) {
                @strongify(self);
                 return [[[self saveUserWithModel:value] ignoreValues] concat:[RACSignal return :value]];
            }];
        }];
        
        [[_userInfoCommand.executionSignals concat] subscribeNext:^(XPLoginModel * x) {
            @strongify(self);
            self.model = x;
        }];
        
        XPViewModelShortHand(_userInfoCommand)
    }
    return _userInfoCommand;
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

- (RACCommand *)listCommand
{
    if(!_listCommand) {
        @weakify(self);
        _listCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager bankAdvertisementsList];
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
