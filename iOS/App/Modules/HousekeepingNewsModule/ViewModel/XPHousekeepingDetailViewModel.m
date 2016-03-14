//
//  XPHousekeepingDetailViewModel.m
//  XPApp
//
//  Created by jy on 16/2/23.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPHousekeepingDetailViewModel.h"
#import "XPAPIManager+HousekeepingNews.h"
#import "XPAPIManager+SecondHand.h"

@interface XPHousekeepingDetailViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *detailCommand;
@property (nonatomic, strong, readwrite) RACCommand *collectionCommand;
@property (nonatomic, strong, readwrite) RACCommand *cancelCollectionCommand;
@property (nonatomic, strong, readwrite) RACCommand *deleteCommand;
@property (nonatomic, assign, readwrite) BOOL isDeleteSuccess;
@property (nonatomic, assign, readwrite) BOOL isCollectionSuccess;
@property (nonatomic, assign, readwrite) BOOL isFavorit;

@end

@implementation XPHousekeepingDetailViewModel

- (instancetype)init {
	if (self = [super init]) {

	}
	return self;
}

- (RACCommand *)detailCommand
{
    if(!_detailCommand) {
        @weakify(self);
        _detailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager detailOfHousekeepingWithHousekeepingItemId:self.housekeepingItemId];//传id
        }];
        [[_detailCommand.executionSignals concat] subscribeNext:^(XPHousekeepingDetailModel *x) {
            @strongify(self);
            self.model = x;
            self.isFavorit = self.model.isFavorite;
        }];
        XPViewModelShortHand(_detailCommand)
    }
    return _detailCommand;
}

//收藏
- (RACCommand *)collectionCommand
{
    if(!_collectionCommand) {
        @weakify(self);
        _collectionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager collectionTopicOrSecondHandWithFavoriteId:self.housekeepingItemId type:CollectionTypeOfHousekeeping];
        }];
        [[_collectionCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            if([x isEqualToString:@"success"]) {
                self.isFavorit = YES;
            }
            _cancelCollectionCommand = nil;
        }];
        XPViewModelShortHand(_collectionCommand)
    }
    return _collectionCommand;
}

- (RACCommand *)cancelCollectionCommand
{
    if(!_cancelCollectionCommand) {
        @weakify(self);
        _cancelCollectionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager cancelCollectionTopicOrSecondHandWithFavoriteId:self.housekeepingItemId type:CollectionTypeOfHousekeeping];
        }];
        [[_cancelCollectionCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            if([x isEqualToString:@"success"]) {
                self.isFavorit = NO;
            }
            _collectionCommand = nil;
        }];
        XPViewModelShortHand(_cancelCollectionCommand)
    }
    return _cancelCollectionCommand;
}

- (RACCommand *)deleteCommand
{
    if(!_deleteCommand) {
        @weakify(self);
        _deleteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager deleteHousekeepingWithHousekeepingItemId:self.housekeepingItemId];
        }];
        [[_deleteCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            self.isDeleteSuccess = YES;
        }];
        XPViewModelShortHand(_deleteCommand)
    }
    return _deleteCommand;
}

@end 
