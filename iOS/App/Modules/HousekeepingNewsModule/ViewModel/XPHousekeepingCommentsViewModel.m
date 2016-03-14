//
//  XPHousekeepingCommentsViewModel.m
//  XPApp
//
//  Created by jy on 16/2/23.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPHousekeepingCommentsViewModel.h"
#import "XPSecondHandCommentsModel.h"
#import "XPAPIManager+HousekeepingNews.h"

@interface XPHousekeepingCommentsViewModel ()
@property (nonatomic, strong, readwrite) RACCommand *reloadCommentsCommand;
@property (nonatomic, strong, readwrite) RACCommand *moreCommentsCommand;
@property (nonatomic, strong, readwrite) RACCommand *replyCommand;
@property (nonatomic, strong, readwrite) NSString *lastHousekeepingCommentId;
@property (nonatomic, assign, readwrite) BOOL isNoMoreDate;

@end

@implementation XPHousekeepingCommentsViewModel

- (instancetype)init {
	if (self = [super init]) {
        self.isNoMoreDate = NO;
	}
	return self;
}

- (RACCommand *)reloadCommentsCommand
{
    if(!_reloadCommentsCommand) {
        @weakify(self);
        _reloadCommentsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager housekeepingCommentsWithHousekeepingItemId:self.housekeepingItemId housekeepingCommentId:nil];
        }];
        [[_reloadCommentsCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            self.commentsList = x;
            if(self.commentsList.count > 0) {
                XPSecondHandCommentsModel *lastModel = [self.commentsList lastObject];
                self.lastHousekeepingCommentId = lastModel.housekeepingCommentId;
            }
            if ([(NSArray *)x count] < 20) {
                self.isNoMoreDate = YES;
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
            return [self.apiManager housekeepingCommentsWithHousekeepingItemId:self.housekeepingItemId housekeepingCommentId:_lastHousekeepingCommentId];
        }];
        [[_moreCommentsCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            [self.commentsList addObjectsFromArray:x];
            self.commentsList = self.commentsList;
            if(self.commentsList.count > 0) {
                XPSecondHandCommentsModel *lastModel = [self.commentsList lastObject];
                self.lastHousekeepingCommentId = lastModel.housekeepingCommentId;
            }
            if ([(NSArray *)x count] < 20) {
                self.isNoMoreDate = YES;
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
            return [self.apiManager reolyFroumCommentWithHousekeepingItemId:self.housekeepingItemId content:self.content replyOf:self.replyOf];
        }];
        [[_replyCommand.executionSignals concat] subscribeNext:^(XPSecondHandCommentsModel *x) {
            @strongify(self);
            if(self.replyOf.length < 1) {
                [self.commentsList insertObject:x atIndex:0];
                XPSecondHandCommentsModel *lastModel = [self.commentsList lastObject];
                self.lastHousekeepingCommentId = lastModel.housekeepingCommentId;
            } else {
                NSInteger index = 0;
                for(XPSecondHandCommentsModel *model in self.commentsList) {
                    if([model.housekeepingCommentId isEqualToString:x.housekeepingCommentId]) {
                        index = [self.commentsList indexOfObject:model];
                    }
                }
                [self.commentsList replaceObjectAtIndex:index withObject:x];
            }
            self.commentCount = self.commentCount + 1;
            self.commentsList = self.commentsList;
        }];
        XPViewModelShortHand(_replyCommand)
    }
    return _replyCommand;
}

@end 
