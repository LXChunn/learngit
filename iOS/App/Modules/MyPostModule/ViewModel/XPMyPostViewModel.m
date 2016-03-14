//
//  XPMyPostViewModel.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/8.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+Getmypost.h"
#import "XPMyPostViewModel.h"
#import "XPSecondHandItemsListModel.h"
#import "XPTopicModel.h"
#import "XPOtherForumModel.h"

@interface XPMyPostViewModel ()
@property (nonatomic, strong, readwrite) RACCommand *myforumtopicsCommand;
@property (nonatomic, strong, readwrite) RACCommand *moreForumtopicsCommand;
@property (nonatomic, strong, readwrite) RACCommand *mysecondhandCommand;
@property (nonatomic, strong, readwrite) RACCommand *moreSecondHandCommand;
@property (nonatomic, strong, readwrite) RACCommand *otherForumCommand;
@property (nonatomic, strong, readwrite) RACCommand *moreOtherForumCommand;
@property (nonatomic, strong, readwrite) NSArray *postArray;
@property (nonatomic, assign, readwrite) BOOL isNoMoreDate;

@end
@implementation XPMyPostViewModel

- (instancetype)init
{
    if(self = [super init]) {
        self.lastid = @"";
        self.pagesize = 20;
        self.isNoMoreDate = NO;
    }
    
    return self;
}

- (RACCommand *)myforumtopicsCommand
{
    if(!_myforumtopicsCommand) {
        @weakify(self);
        _myforumtopicsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager getMyForumtopicsWithPageSize:self.pagesize lasttopicid:nil];
        }];
        [[[_myforumtopicsCommand executionSignals] concat] subscribeNext:^(NSArray *x) {
            @strongify(self);
            if(x.count > 0) {
                XPTopicModel *model = [x lastObject];
                self.lastid = model.forumTopicId;
            }
            self.postArray = x;
            if (x.count < 20) {
                self.isNoMoreDate = YES;
            }
        }];
        XPViewModelShortHand(_myforumtopicsCommand)
    }
    
    return _myforumtopicsCommand;
}


- (RACCommand *)moreForumtopicsCommand
{
    if(!_moreForumtopicsCommand) {
        @weakify(self);
        _moreForumtopicsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager getMyForumtopicsWithPageSize:self.pagesize lasttopicid:self.lastid];
        }];
        [[[_moreForumtopicsCommand executionSignals] concat] subscribeNext:^(NSArray *x) {
            @strongify(self);
            if(x.count > 0) {
                XPTopicModel *model = [x lastObject];
                self.lastid = model.forumTopicId;
            }
            if (self.postArray) {
                self.postArray = [self.postArray arrayByAddingObjectsFromArray:x];
            }else{
                self.postArray = x;
            }
            if (x.count < 20) {
                self.isNoMoreDate = YES;
            }
        }];
        XPViewModelShortHand(_moreForumtopicsCommand)
    }
    
    return _moreForumtopicsCommand;

}

- (RACCommand *)mysecondhandCommand
{
    if(!_mysecondhandCommand) {
        @weakify(self);
        _mysecondhandCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager getMyForumSecondHandtopicsWithPageSize:self.pagesize lastitemid:nil];
        }];
        [[[_mysecondhandCommand executionSignals] concat] subscribeNext:^(NSArray *x) {
            @strongify(self);
            if(x.count > 0) {
                XPSecondHandItemsListModel *model = [x lastObject];
                self.lastid = model.secondhandItemId;
            }
            self.postArray = x;
            if (x.count < 20) {
                self.isNoMoreDate = YES;
            }
        }];
        XPViewModelShortHand(_mysecondhandCommand)
    }
    
    return _mysecondhandCommand;
}

- (RACCommand *)moreSecondHandCommand
{
    if(!_moreForumtopicsCommand) {
        @weakify(self);
        _moreForumtopicsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager getMyForumSecondHandtopicsWithPageSize:self.pagesize lastitemid:self.lastid];
        }];
        [[[_moreForumtopicsCommand executionSignals] concat] subscribeNext:^(NSArray *x) {
            @strongify(self);
            if(x.count > 0) {
                XPSecondHandItemsListModel *model = [x lastObject];
                self.lastid = model.secondhandItemId;
            }
            if (self.postArray) {
                self.postArray = [self.postArray arrayByAddingObjectsFromArray:x];
            }else{
                self.postArray = x;
            }
            if (x.count < 20) {
                self.isNoMoreDate = YES;
            }
        }];
        XPViewModelShortHand(_moreForumtopicsCommand)
    }
    
    return _moreForumtopicsCommand;
}

- (RACCommand *)otherForumCommand
{
    if(!_otherForumCommand) {
        @weakify(self);
        _otherForumCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager getOtherForm:nil];
        }];
        [[[_otherForumCommand executionSignals] concat] subscribeNext:^(NSArray *x) {
            @strongify(self);
            if(x.count > 0) {
                XPOtherForumModel *model = [x lastObject];
                self.lastid = model.otherItemId;
            }
            self.postArray = x;
            if (x.count < 20) {
                self.isNoMoreDate = YES;
            }
        }];
        XPViewModelShortHand(_otherForumCommand)
    }
    
    return _otherForumCommand;
}

- (RACCommand *)moreOtherForumCommand
{
    if(!_moreOtherForumCommand) {
        @weakify(self);
        _moreOtherForumCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager getOtherForm:self.lastid];
        }];
        [[[_moreOtherForumCommand executionSignals] concat] subscribeNext:^(NSArray *x) {
            @strongify(self);
            if(x.count > 0) {
                XPOtherForumModel *model = [x lastObject];
                self.lastid = model.otherItemId;
            }
            if (self.postArray) {
                self.postArray = [self.postArray arrayByAddingObjectsFromArray:x];
            }else{
                self.postArray = x;
            }
            if (x.count < 20) {
                self.isNoMoreDate = YES;
            }
        }];
        XPViewModelShortHand(_moreOtherForumCommand)
    }
    
    return _moreOtherForumCommand;
}


@end
