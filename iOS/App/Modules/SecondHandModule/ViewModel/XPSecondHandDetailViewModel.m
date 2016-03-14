//
//  XPSecondHandDetailViewModel.m
//  XPApp
//
//  Created by jy on 15/12/30.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "JSONModel.h"
#import "XPAPIManager+SecondHand.h"
#import "XPSecondHandDetailViewModel.h"
#import "XPSecondHandReplyModel.h"

@interface XPSecondHandDetailViewModel ()
@property (nonatomic, strong, readwrite) RACCommand *detailCommand;
@property (nonatomic, strong, readwrite) RACCommand *reloadCommentsCommand;
@property (nonatomic, strong, readwrite) RACCommand *moreCommentsCommand;
@property (nonatomic, strong, readwrite) XPSecondHandDetailModel *detailModel;
@property (nonatomic, strong, readwrite) RACCommand *replyCommand;
@property (nonatomic, strong, readwrite) RACCommand *collectionCommand;
@property (nonatomic, strong, readwrite) RACCommand *cancelCollectionCommand;
@property (nonatomic, strong, readwrite) RACCommand *deleteCommand;
@property (nonatomic, strong, readwrite) RACCommand *closeCommand;
@property (nonatomic, strong, readwrite) NSString *lastsecondCommentId;
@property (nonatomic, assign, readwrite) BOOL isCloseSuccess;
@property (nonatomic, assign, readwrite) BOOL isDeleteSuccess;
@property (nonatomic, assign, readwrite) BOOL isFavorite;
@property (nonatomic, assign, readwrite) BOOL isNoMoreDate;
@end

@implementation XPSecondHandDetailViewModel

- (instancetype)init
{
    if(self = [super init]) {
        self.isNoMoreDate = NO;
    }
    return self;
}

- (RACCommand *)detailCommand
{
    if(!_detailCommand) {
        @weakify(self);
        _detailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager secondHandDetailWithSecondhandItemId:self.secondHandItemId];
        }];
        [[_detailCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            self.detailModel = x;
            self.isFavorite = self.detailModel.isFavorite;
        }];
        XPViewModelShortHand(_detailCommand)
    }
    
    return _detailCommand;
}

- (RACCommand *)collectionCommand
{
    if(!_collectionCommand) {
        @weakify(self);
        _collectionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager collectionTopicOrSecondHandWithFavoriteId:self.secondHandItemId type:self.type];
        }];
        [[_collectionCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            if([x isEqualToString:@"success"]) {
                self.isFavorite = YES;
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
            return [self.apiManager cancelCollectionTopicOrSecondHandWithFavoriteId:self.secondHandItemId type:self.type];
        }];
        [[_cancelCollectionCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            if([x isEqualToString:@"success"]) {
                self.isFavorite = NO;
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
            return [self.apiManager secondHandCancelWithSecondhandItemId:self.secondHandItemId];
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

- (RACCommand *)closeCommand
{
    if(!_closeCommand) {
        @weakify(self);
        _closeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager secondHandCloseWithSecondhandItemId:self.secondHandItemId];
        }];
        [[_closeCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            if([x isEqualToString:@"success"]) {
                self.isCloseSuccess = YES;
            }
        }];
        XPViewModelShortHand(_closeCommand)
    }
    
    return _closeCommand;
}

- (RACCommand *)reloadCommentsCommand
{
    if(!_reloadCommentsCommand) {
        @weakify(self);
        _reloadCommentsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager secondHandCommentListWithSecondhandItemId:self.secondHandItemId pageSize:1 secondhandCommentId:nil];
        }];
        [[_reloadCommentsCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            self.commentsList = x;
            if ([(NSArray *)x count] < 20){
                self.isNoMoreDate = YES;
            }
            if(self.commentsList.count > 0) {
                XPSecondHandCommentsModel *lastModel = [self.commentsList lastObject];
                self.lastsecondCommentId = lastModel.secondhandCommentId;
            }
        }];
        XPViewModelShortHand(_reloadCommentsCommand)
    }
    return _reloadCommentsCommand;
}

- (RACCommand *)moreCommentsCommand
{
    if(!_moreCommentsCommand) {
        @weakify(self);
        _moreCommentsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager secondHandCommentListWithSecondhandItemId:self.secondHandItemId pageSize:1 secondhandCommentId:self.lastsecondCommentId];
        }];
        [[_moreCommentsCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            [self.commentsList addObjectsFromArray:x];
            self.commentsList = self.commentsList;
            if ([(NSArray *)x count] < 20){
                self.isNoMoreDate = YES;
            }
            if(self.commentsList.count > 0) {
                XPSecondHandCommentsModel *lastModel = [self.commentsList objectAtIndex:self.commentsList.count - 1];
                self.lastsecondCommentId = lastModel.secondhandCommentId;
            }
        }];
        XPViewModelShortHand(_moreCommentsCommand)
    }
    
    return _moreCommentsCommand;
}

- (RACCommand *)replyCommand
{
    if(!_replyCommand) {
        @weakify(self);
        _replyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager secondHandCreateCommentWithSecondhandItemId:_secondHandItemId content:self.content replyOf:self.replyOf];
        }];
        [[_replyCommand.executionSignals concat] subscribeNext:^(XPSecondHandCommentsModel *x) {
            @strongify(self);
            if(self.replyOf.length < 1) {
                [self.commentsList insertObject:x atIndex:0];
                XPSecondHandCommentsModel *lastModel = [self.commentsList lastObject];
                self.lastsecondCommentId = lastModel.secondhandCommentId;
            } else {
                NSInteger index = 0;
                for(XPSecondHandCommentsModel *model in self.commentsList) {
                    if([model.secondhandCommentId isEqualToString:x.secondhandCommentId]) {
                        index = [self.commentsList indexOfObject:model];
                    }
                }
                [self.commentsList replaceObjectAtIndex:index withObject:x];
            }
            self.detailModel.commentsCount = self.detailModel.commentsCount + 1;
            self.commentsList = self.commentsList;
        }];
        XPViewModelShortHand(_replyCommand)
    }
    
    return _replyCommand;
}

@end
