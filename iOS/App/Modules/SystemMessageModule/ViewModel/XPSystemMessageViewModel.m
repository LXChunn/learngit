//
//  XPSystemMessageViewModel.m
//  XPApp
//
//  Created by jy on 16/1/15.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPSystemMessageViewModel.h"
#import "XPAPIManager+SystemMessage.h"
#import "XPSystemMessageModel.h"


@interface XPSystemMessageViewModel ()
@property (nonatomic, strong, readwrite) RACCommand *reloadCommand;
@property (nonatomic, strong, readwrite) RACCommand *moreCommand;
@property (nonatomic, strong, readwrite) NSArray *list;
@property (nonatomic, strong, readwrite) NSString *lastSystemId;
@property (nonatomic, assign, readwrite) BOOL isNoMoreDate;

@end

@implementation XPSystemMessageViewModel

- (instancetype)init {
	if (self = [super init]) {
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
            return [self.apiManager unReadSystemMesageListWithLastSystemMessage:nil];
        }];
        [[_reloadCommand.executionSignals concat] subscribeNext:^(NSArray * x) {
            @strongify(self);
            if(x.count > 0) {
                XPSystemMessageModel *lastModel = [x lastObject];
                self.lastSystemId = lastModel.systemMessageId;
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
            return [self.apiManager unReadSystemMesageListWithLastSystemMessage:self.lastSystemId];
        }];
        [[_moreCommand.executionSignals concat] subscribeNext:^(NSArray * x) {
            @strongify(self);
            if(x.count > 0) {
                XPSystemMessageModel *lastModel = [x lastObject];
                self.lastSystemId = lastModel.systemMessageId;
            }
            if (self.list) {
                NSMutableArray * tmpArray = [NSMutableArray arrayWithArray:self.list];
                for (int i = 0; i< [x count]; i++) {
                    XPSystemMessageModel *model = x[i];
                    [tmpArray insertObject:model atIndex:i];
                }
                self.list = tmpArray;
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
