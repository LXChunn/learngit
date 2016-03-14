//
//  XPSettingViewModel.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/12.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPSettingViewModel.h"
#import "XPAPIManager+Setting.h"

@interface XPSettingViewModel()
@property (nonatomic,strong,readwrite) RACCommand *requestCommand;
@property (nonatomic,assign,readwrite) BOOL isSuccess;
@property (nonatomic,strong,readwrite) NSString *successMessage;
@end
@implementation XPSettingViewModel

- (instancetype)init
{
    if (self = [super init]) {
        self.type = nil;
        self.content = nil;
        self.version = 0;
    }
    return self;
}

- (RACCommand *)requestCommand
{
    if(!_requestCommand) {
        @weakify(self);
        _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager sendSuggestionWithPhoneType:self.type content:self.content version:self.version];
        }];
        [[[_requestCommand executionSignals] concat] subscribeNext:^(id x) {
            @strongify(self);
            self.isSuccess = YES;
        }];
        XPViewModelShortHand(_requestCommand)
    }
    return _requestCommand;
}
@end
