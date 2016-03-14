//
//  XPEventDetailViewModel.m
//  XPApp
//
//  Created by jy on 16/1/9.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+CreatePost.h"
#import "XPAPIManager+EventDetail.h"
#import "XPAPIManager+SecondHand.h"
#import "XPEventDetailViewModel.h"

@interface XPEventDetailViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *detailCommand;
@property (nonatomic, strong, readwrite) RACCommand *joinEventCommand;
@property (nonatomic, strong, readwrite) RACCommand *collectionCommand;
@property (nonatomic, strong, readwrite) RACCommand *cancelCollectionCommand;
@property (nonatomic, strong, readwrite) RACCommand *deleteCommand;
@property (nonatomic, strong, readwrite) RACCommand *closeCommand;
@property (nonatomic, strong, readwrite) XPDetailModel *model;
@property (nonatomic, assign, readwrite) BOOL isDeleteSuccess;
@property (nonatomic, assign, readwrite) BOOL isJoinSuccess;
@property (nonatomic, assign, readwrite) BOOL isFavorit;

@end

@implementation XPEventDetailViewModel

- (instancetype)init
{
    if(self = [super init]) {
    }
    
    return self;
}

- (RACCommand *)detailCommand
{
    if(!_detailCommand) {
        @weakify(self);
        _detailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager eventDetailWithForumtopicid:self.forumtopicId];//传id
        }];
        [[_detailCommand.executionSignals concat] subscribeNext:^(XPDetailModel *x) {
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
            return [self.apiManager collectionTopicOrSecondHandWithFavoriteId:self.forumtopicId type:1];
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
            return [self.apiManager cancelCollectionTopicOrSecondHandWithFavoriteId:self.forumtopicId type:1];
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
            return [self.apiManager deletePostWithForumtopicid:self.forumtopicId];
        }];
        [[_deleteCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            if([x isEqualToString:@"success"]) {
                self.isDeleteSuccess = YES;
            }
        }];
        XPViewModelShortHand(_deleteCommand)
    }
    
    return _deleteCommand;
}

- (RACCommand *)joinEventCommand
{
    if(!_joinEventCommand) {
        @weakify(self);
        _joinEventCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager joinEventWithForumtopicid:self.forumtopicId];
        }];
        [[_joinEventCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            if([x isEqualToString:@"success"]) {
                self.isJoinSuccess = YES;
            }
        }];
        XPViewModelShortHand(_joinEventCommand)
    }
    
    return _joinEventCommand;
}

@end
