//
//  XPDetailViewModel.m
//  XPApp
//
//  Created by Mac OS on 15/12/31.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+CreatePost.h"
#import "XPAPIManager+SecondHand.h"
#import "XPAPIManager+Vote.h"
#import "XPDetailModel.h"
#import "XPDetailViewModel.h"
#import "XPOptionModel.h"
#import "XPSecondHandCommentsModel.h"
@interface XPDetailViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *detailCommand;
@property (nonatomic, strong, readwrite) RACCommand *collectionCommand;
@property (nonatomic, strong, readwrite) RACCommand *cancelCollectionCommand;
@property (nonatomic, strong, readwrite) RACCommand *deleteCommand;
@property (nonatomic, strong, readwrite) RACCommand *closeCommand;
@property (nonatomic, strong, readwrite) RACCommand *voteCommand;
@property (nonatomic, assign, readwrite) BOOL isDeleteSuccess;
@property (nonatomic, assign, readwrite) BOOL isCollectionSuccess;
@property (nonatomic, assign, readwrite) BOOL isCloseSuccess;
@property (nonatomic, assign, readwrite) BOOL isVoteSuccess;
@property (nonatomic, assign, readwrite) BOOL isFavorit;

@end

@implementation XPDetailViewModel

- (RACCommand *)detailCommand
{
    if(!_detailCommand) {
        @weakify(self);
        _detailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager detailPostWithForumtopicid:self.forumtopicId];//传id
        }];
        [[_detailCommand.executionSignals concat] subscribeNext:^(XPDetailModel *x) {
            @strongify(self);
            [x.extra dictionaryWithOptions];
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
            return [self.apiManager collectionTopicOrSecondHandWithFavoriteId:self.forumtopicId type:self.type];
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
            return [self.apiManager cancelCollectionTopicOrSecondHandWithFavoriteId:self.forumtopicId type:self.type];
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
            self.isDeleteSuccess = YES;
        }];
        XPViewModelShortHand(_deleteCommand)
    }
    
    return _deleteCommand;
}

- (RACCommand *)closeCommand
{
    if(!_closeCommand) {
        @weakify(self);
        _closeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager closeVoteWithFormtopicId:self.forumtopicId];
        }];
        [[_closeCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            self.isCloseSuccess = YES;
        }];
        XPViewModelShortHand(_closeCommand)
    }
    
    return _closeCommand;
}

- (RACCommand *)voteCommand
{
    if(!_voteCommand) {
        @weakify(self);
        _voteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager voteWithforumTopicId:self.forumtopicId voteOptionId:self.voteOptionId];
        }];
        [[_voteCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            self.isVoteSuccess = YES;
        }];
        XPViewModelShortHand(_voteCommand)
    }
    
    return _voteCommand;
}

@end
