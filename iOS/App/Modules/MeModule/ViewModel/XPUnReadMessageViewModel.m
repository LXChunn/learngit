//
//  XPUnReadMessageViewModel.m
//  XPApp
//
//  Created by jy on 16/1/9.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+PrivateLetter.h"
#import "XPUnReadMessageViewModel.h"

@interface XPUnReadMessageViewModel ()
@property (nonatomic, strong, readwrite) RACCommand *unReadCommand;
@property (nonatomic, assign, readwrite) NSInteger unReadMessageCounte;
@property (nonatomic, strong, readwrite) RACCommand *unReadSystemMessageCommand;
@property (nonatomic, assign, readwrite) NSInteger unReadSystemMessageCounte;

@end

@implementation XPUnReadMessageViewModel

- (instancetype)init
{
    if(self = [super init]) {
    }
    
    return self;
}

- (RACCommand *)unReadCommand
{
    if(!_unReadCommand) {
        @weakify(self);
        _unReadCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager checkUnreadMessage];
        }];
        [[_unReadCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            self.unReadMessageCounte = [x integerValue];
            self.unReadCommand = nil;
        }];
        XPViewModelShortHand(_unReadCommand)
    }
    return _unReadCommand;
}

- (RACCommand *)unReadSystemMessageCommand
{
    if(!_unReadSystemMessageCommand) {
        @weakify(self);
        _unReadSystemMessageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager checkUnreadSystemMessage];
        }];
        [[_unReadSystemMessageCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            self.unReadSystemMessageCounte = [x integerValue];
            self.unReadSystemMessageCommand = nil;
        }];
        XPViewModelShortHand(_unReadSystemMessageCommand)
    }
    return _unReadSystemMessageCommand;
}

@end
