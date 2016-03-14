//
//  XPUserInfoModel.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/6.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+XPChangeUserIn.h"
#import "XPUserViewModel.h"

@interface XPUserViewModel ()
@property (nonatomic, strong, readwrite) RACCommand *updateCommand;
@property (nonatomic, strong, readwrite) NSString *successMessage;
@end

@implementation XPUserViewModel
- (instancetype)init
{
    if(self = [super init]) {
        self.avataUrl = nil;
        self.nickName = nil;
        self.gender = 0;
    }
    
    return self;
}

- (RACCommand *)updateCommand
{
    if(!_updateCommand) {
        @weakify(self);
        _updateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager createPostWithAvatarUrl:self.avataUrl nickName:self.nickName gender:self.gender];
        }];
        [[[_updateCommand executionSignals] concat] subscribeNext:^(id x) {
            @strongify(self);
            self.successMessage = x;
        }];
        XPViewModelShortHand(_updateCommand)
    }
    
    return _updateCommand;
}

@end
