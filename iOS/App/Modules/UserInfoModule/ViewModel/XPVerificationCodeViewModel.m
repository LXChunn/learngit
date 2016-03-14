//
//  XPverificationCodeViewModel.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/15.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPVerificationCodeViewModel.h"
#import "XPLoginViewModel.h"
#import "XPAPIManager+Login.h"
#import "XPAPIManager+XPChangeUserIn.h"

@interface XPVerificationCodeViewModel ()

@property(nonatomic,strong,readwrite)RACCommand *verCodelCommand;
@property (nonatomic,assign,readwrite)BOOL isRecciveSuccess;

@end

@implementation XPVerificationCodeViewModel

- (instancetype)init {
	if (self = [super init]) {

	}
	return self;
}

- (RACCommand *)verCodelCommand
{
    if(!_verCodelCommand) {
        @weakify(self);
        _verCodelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager getVerCodeWithPhone:self.phone];
        }];
        [[[_verCodelCommand executionSignals] concat] subscribeNext:^(id x) {
            @strongify(self);
            self.isRecciveSuccess = YES;
        }];
        XPViewModelShortHand(_verCodelCommand)
    }
    
    return _verCodelCommand;
}
@end 
