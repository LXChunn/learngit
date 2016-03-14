//
//  XPMyCommentViewModel.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/8.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+GetMyComment.h"
#import "XPMyCommentListModel.h"
#import "XPMyCommentViewModel.h"
#import "XPTopicModel.h"

@interface XPMyCommentViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *mycommentsCommand;
@property (nonatomic, strong, readwrite) RACCommand *moreCommentsCommand;
@property (nonatomic, strong, readwrite) NSArray *myCommentArray;
@property (nonatomic, assign, readwrite) BOOL isNoMoreDate;

@end

@implementation XPMyCommentViewModel

- (instancetype)init
{
    if(self = [super init]) {
        self.type = nil;
        self.lastId = nil;
        self.pageSize = 20;
        self.isNoMoreDate = NO;
    }
    return self;
}

- (RACCommand *)mycommentsCommand
{
    if(!_mycommentsCommand) {
        @weakify(self);
        _mycommentsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager getMyCommentsWithType:self.type pageSize:self.pageSize lastCommentid:nil];
        }];
        [[[_mycommentsCommand executionSignals] concat] subscribeNext:^(NSArray *x) {
            @strongify(self);
            if(x.count > 0) {
                if(x.count > 0) {
                XPMyCommentListModel *model = [x lastObject];
                self.lastId = model.commentId;
                }
            }
            self.myCommentArray = x;
            if (x.count < 20) {
                self.isNoMoreDate = YES;
            }
        }];
        XPViewModelShortHand(_mycommentsCommand)
    }
    return _mycommentsCommand;
}

- (RACCommand *)moreCommentsCommand
{
    if(!_moreCommentsCommand) {
        @weakify(self);
        _moreCommentsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager getMyCommentsWithType:self.type pageSize:self.pageSize lastCommentid:self.lastId];
        }];
        [[[_moreCommentsCommand executionSignals] concat] subscribeNext:^(NSArray *x) {
            @strongify(self);
            if(x.count > 0) {
                XPMyCommentListModel *model = [x lastObject];
                self.lastId = model.commentId;
            }
            if (self.myCommentArray) {
                self.myCommentArray = [self.myCommentArray arrayByAddingObjectsFromArray:x];
            }else{
                self.myCommentArray = x;
            }
            if (x.count < 20) {
                self.isNoMoreDate = YES;
            }
        }];
        XPViewModelShortHand(_moreCommentsCommand)
    }
    return _moreCommentsCommand;
}
@end
