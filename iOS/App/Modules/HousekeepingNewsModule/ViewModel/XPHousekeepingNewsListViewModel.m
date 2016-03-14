//
//  XPHousekeepingNewsListViewModel.m
//  XPApp
//
//  Created by jy on 16/2/22.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPHousekeepingNewsListViewModel.h"
#import "XPAPIManager+HousekeepingNews.h"
#import "XPHousekeepingListModel.h"

@interface XPHousekeepingNewsListViewModel ()
@property (nonatomic, strong, readwrite) RACCommand *reloadCommand;
@property (nonatomic, strong, readwrite) RACCommand *moreCommand;
@property (nonatomic, strong, readwrite) NSArray *list;
@property (nonatomic, strong, readwrite) NSString *lastItemId;
@property (nonatomic, assign, readwrite) BOOL isNoMoreDate;

@end

@implementation XPHousekeepingNewsListViewModel

- (instancetype)init {
	if (self = [super init]) {
        self.isNoMoreDate = NO;
	}
	return self;
}

- (RACCommand *)reloadCommand{
    if(!_reloadCommand) {
        @weakify(self);
        _reloadCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager housekeepingListWithLastItemId:nil];
        }];
        [[_reloadCommand.executionSignals concat] subscribeNext:^(NSArray * x) {
            @strongify(self);
            if(x.count > 0) {
                XPHousekeepingListModel *lastModel = [x lastObject];
                self.lastItemId = lastModel.housekeepingItemId;
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
            return [self.apiManager housekeepingListWithLastItemId:_lastItemId];
        }];
        [[_moreCommand.executionSignals concat] subscribeNext:^(NSArray * x) {
            @strongify(self);
            if(x.count > 0) {
                XPHousekeepingListModel *lastModel = [x lastObject];
                self.lastItemId = lastModel.housekeepingItemId;
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
