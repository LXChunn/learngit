//
//  XPUserInfoViewModel.m
//  XPApp
//
//  Created by jy on 15/12/31.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPUserInfoViewModel.h"
#import "XPAPIManager+Login.h"

@interface XPUserInfoViewModel ()
@property (nonatomic, strong, readwrite) XPLoginModel *model;
@property (nonatomic, strong,readwrite) RACCommand *userInfoCommand;

@end

@implementation XPUserInfoViewModel

- (RACCommand *)userInfoCommand
{
    if(!_userInfoCommand) {
        @weakify(self);
        _userInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [self.apiManager userInfo];
        }];
        [[_userInfoCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            self.model = x;
        }];
        XPViewModelShortHand(_userInfoCommand)
    }
    return _userInfoCommand;
}

@end 
