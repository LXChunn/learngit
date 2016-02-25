//
//  XPVoteViewModel.m
//  XPApp
//
//  Created by Mac OS on 15/12/31.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPVoteViewModel.h"
#import "XPAPIManager+Vote.h"

@interface XPVoteViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *createpostCommand;
@property (nonatomic, strong) RACSignal *validSignal;

@end

@implementation XPVoteViewModel

- (instancetype)init {
	if (self = [super init]) {
        self.type = nil;
        self.title = nil;
        self.content = nil;
        self.options = nil;
	}
	return self;
}
- (RACSignal *)validSignal
{
    return [RACSignal combineLatest:@[RACObserve(self, title), RACObserve(self, content)] reduce:^id ( NSString *content,NSString *title){
        return @((content.length >= 10 && content.length <= 2000)&&(title.length >= 1 && title.length <= 20 ));
    }];
    
    
}

- (RACCommand *)voteCommand
{
    if(!_createpostCommand) {
        @weakify(self);
        _createpostCommand = [[RACCommand alloc] initWithEnabled:self.validSignal signalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager voteWithaccessToken:self.accessToken withtitle:self.title withcontent:self.content withtype:self.type withoptions:self.options];//传参
        }];
        [[[_createpostCommand executionSignals] concat] subscribeNext:^(id x) {
            @strongify(self);
            self.createpostFinished = YES;
        }];
        XPViewModelShortHand(_createpostCommand)
    }
    return _createpostCommand;
}

@end
