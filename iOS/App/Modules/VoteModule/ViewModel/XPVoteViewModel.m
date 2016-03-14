//
//  XPVoteViewModel.m
//  XPApp
//
//  Created by Mac OS on 15/12/31.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+Vote.h"
#import "XPVoteViewModel.h"

@interface XPVoteViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *voteCommand;
@property (nonatomic, strong, readwrite) NSString *successMessage;

@end

@implementation XPVoteViewModel

- (instancetype)init
{
    if(self = [super init]) {
        self.type = nil;
        self.title = nil;
        self.content = nil;
        self.options = nil;
    }
    
    return self;
}

- (RACCommand *)voteCommand
{
    if(!_voteCommand) {
        @weakify(self);
        _voteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager postVoteWithtitle:self.title content:self.content type:self.type withoptions:self.options];//传参
        }];
        [[[_voteCommand executionSignals] concat] subscribeNext:^(id x) {
            @strongify(self);
            self.successMessage = x;
        }];
        XPViewModelShortHand(_voteCommand)
    }
    
    return _voteCommand;
}

@end
