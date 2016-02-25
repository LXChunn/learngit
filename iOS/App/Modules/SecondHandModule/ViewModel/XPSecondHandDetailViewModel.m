//
//  XPSecondHandDetailViewModel.m
//  XPApp
//
//  Created by jy on 15/12/30.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPSecondHandDetailViewModel.h"
#import "XPAPIManager+SecondHand.h"

@interface XPSecondHandDetailViewModel ()
@property (nonatomic,strong,readwrite) RACCommand *detailCommand;
@property (nonatomic,strong,readwrite) XPSecondHandDetailModel *detailModel;
@property (nonatomic,strong,readwrite) RACCommand *collectionCommand;
@property (nonatomic,strong,readwrite) RACCommand *deleteCommand;
@property (nonatomic,strong,readwrite) RACCommand *closeCommand;
@property (nonatomic,assign,readwrite) BOOL isCollectionSuccess;
@property (nonatomic,assign,readwrite) BOOL isCloseSuccess;
@property (nonatomic,assign,readwrite) BOOL isDeleteSuccess;
@property (nonatomic,assign,readwrite) BOOL isFavorite;
@end

@implementation XPSecondHandDetailViewModel

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
            if ([x isEqualToString:@"success"])
            {
                self.isCollectionSuccess = YES;
                self.isFavorite = !self.isFavorite;
            }
        }];
        XPViewModelShortHand(_collectionCommand)
    }
    return _collectionCommand;
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
            if ([x isEqualToString:@"success"])
            {
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
            if ([x isEqualToString:@"success"])
            {
                self.isCloseSuccess = YES;
            }
        }];
        XPViewModelShortHand(_closeCommand)
    }
    return _closeCommand;
}


@end 
