//
//  XPPrivateMessageDetailViewModel.m
//  XPApp
//
//  Created by jy on 16/1/9.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+PrivateLetter.h"
#import "XPMessageDetailModel.h"
#import "XPPrivateMessageDetailViewModel.h"

@interface XPPrivateMessageDetailViewModel ()
@property (nonatomic, strong, readwrite) RACCommand *reloadCommand;
@property (nonatomic, strong, readwrite) RACCommand *moreCommand;
@property (nonatomic, strong, readwrite) RACCommand *sendMessageCommand;
@property (nonatomic, strong, readwrite) NSMutableArray *list;
@property (nonatomic, strong, readwrite) NSString *lastMessageId;
@property (nonatomic, assign, readwrite) BOOL isSendSuccess;

@end

@implementation XPPrivateMessageDetailViewModel

- (instancetype)init
{
    if(self = [super init]) {
        _isSendSuccess = NO;
        _lastMessageId = nil;
        _contactUserId = nil;
    }
    return self;
}

- (RACCommand *)reloadCommand
{
    if(!_reloadCommand) {
        @weakify(self);
        _reloadCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager checkMessageDetailWithContactUserId:self.contactUserId lastMessageId:nil];
        }];
        [[_reloadCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            if([(NSArray *)x count] > 0) {
                NSArray *sortedArray = [x sortedArrayUsingComparator:^NSComparisonResult (XPMessageDetailModel *message1, XPMessageDetailModel *message2){
                    return [message1.createdAt compare:message2.createdAt];
                }];
                self.list = [NSMutableArray arrayWithArray:sortedArray];
                XPMessageDetailModel *firstModel = [self.list firstObject];
                self.lastMessageId = firstModel.messageId;
            }else{
                self.list = x;
            }
        }];
        XPViewModelShortHand(_reloadCommand)
    }
    return _reloadCommand;
}

- (RACCommand *)moreCommand
{
    if(!_moreCommand) {
        @weakify(self);
        _moreCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager checkMessageDetailWithContactUserId:self.contactUserId lastMessageId:self.lastMessageId];
        }];
        [[_moreCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            if(self.list.count > 0) {
                if (self.lastMessageId.length < 1) {
                    [self.list removeAllObjects];
                }
                for(XPMessageDetailModel *model in x) {
                    [self.list insertObject:model atIndex:0];
                }
                self.list = self.list;
                XPMessageDetailModel *firstModel = [self.list firstObject];
                self.lastMessageId = firstModel.messageId;
            }else{
                self.list = x;
            }
        }];
        XPViewModelShortHand(_moreCommand)
    }
    return _moreCommand;
}

- (RACCommand *)sendMessageCommand
{
    if(!_sendMessageCommand) {
        @weakify(self);
        _sendMessageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager sendMessageWithReceiverId:self.contactUserId content:self.detailModel.content];
        }];
        [[_sendMessageCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            NSString *timestamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            self.detailModel.createdAt = timestamp;
            [self.list addObject:self.detailModel];
            self.list = self.list;
            self.isSendSuccess = YES;
        }];
        XPViewModelShortHand(_sendMessageCommand)
    }
    return _sendMessageCommand;
}

@end
