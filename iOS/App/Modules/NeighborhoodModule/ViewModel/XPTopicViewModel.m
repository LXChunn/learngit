//
//  XPTopicViewModel.m
//  XPApp
//
//  Created by iiseeuu on 15/12/29.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+Topic.h"
#import "XPTopicModel.h"
#import "XPTopicViewModel.h"

@interface XPTopicViewModel ()

@property (nonatomic, strong, readwrite) NSArray *list;
@property (nonatomic, strong, readwrite) RACCommand *reloadCommand;
@property (nonatomic, strong, readwrite) RACCommand *moreCommand;
@property (nonatomic, strong, readwrite) NSString *lastTopicId;
@property (nonatomic, assign, readwrite) BOOL isNoMoreDate;

@end

@implementation XPTopicViewModel

- (instancetype)init
{
    if(self = [super init]) {
        self.isNoMoreDate = NO;
    }
    return self;
}

- (RACCommand *)reloadCommand
{
    if(!_reloadCommand) {
        @weakify(self);
        _reloadCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            return [self.apiManager forumTopicWithLastTopicId:nil];
        }];
        [[_reloadCommand.executionSignals concat] subscribeNext:^(NSArray * x) {
            @strongify(self);
            if(x.count > 0) {
                XPTopicModel *model = [x lastObject];
                self.lastTopicId = model.forumTopicId;
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
        _moreCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            return [self.apiManager forumTopicWithLastTopicId:self.lastTopicId];
        }];
        [[_moreCommand.executionSignals concat] subscribeNext:^(NSArray * x) {
            @strongify(self);
            if(x.count > 0) {
                XPTopicModel *model = [x lastObject];
                self.lastTopicId = model.forumTopicId;
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
