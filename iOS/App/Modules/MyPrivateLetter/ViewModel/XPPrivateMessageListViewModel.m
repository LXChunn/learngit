//
//  XPPrivateMessageListViewModel.m
//  XPApp
//
//  Created by jy on 16/1/9.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+PrivateLetter.h"
#import "XPMessageListModel.h"
#import "XPPrivateMessageListViewModel.h"

@interface XPPrivateMessageListViewModel ()
@property (nonatomic, strong, readwrite) RACCommand *reloadCommand;
@property (nonatomic, strong, readwrite) RACCommand *moreCommand;
@property (nonatomic, strong, readwrite) NSArray *list;
@property (nonatomic, strong, readwrite) NSString *lastTimestamp;
@property (nonatomic, assign, readwrite) BOOL isNoMoreDate;

@end

@implementation XPPrivateMessageListViewModel

- (instancetype)init
{
    if(self = [super init]) {
        self.isNoMoreDate = NO;
    }
    
    return self;
}

- (RACCommand *)reloadCommand
{
    if(!_reloadCommand) {
        @weakify(self);
        _reloadCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager messageBoxListWithLastTimestamp:nil];
        }];
        [[_reloadCommand.executionSignals concat] subscribeNext:^(NSArray * x) {
            @strongify(self);
            if (x.count > 0) {
                XPMessageListModel * lastmodel = [x lastObject];
                self.lastTimestamp = lastmodel.lastMessageDate;
            }
            self.list = x;
            if (x.count < 20) {
                self.isNoMoreDate = YES;
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
            return [self.apiManager messageBoxListWithLastTimestamp:self.lastTimestamp];
        }];
        [[_moreCommand.executionSignals concat] subscribeNext:^(NSArray * x) {
            @strongify(self);
            if (x.count > 0) {
                XPMessageListModel *lastModel = [self.list lastObject];
                self.lastTimestamp = lastModel.lastMessageDate;
            }
            if (self.list) {
                self.list = [self.list arrayByAddingObjectsFromArray:x];
            }else{
                self.list = x;
            }
            if (x.count < 20) {
                self.isNoMoreDate = YES;
            }
        }];
        XPViewModelShortHand(_moreCommand)
    }
    
    return _moreCommand;
}

@end
