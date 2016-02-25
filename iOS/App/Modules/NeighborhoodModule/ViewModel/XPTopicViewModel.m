//
//  XPTopicViewModel.m
//  XPApp
//
//  Created by iiseeuu on 15/12/29.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPTopicViewModel.h"
#import "XPAPIManager+Topic.h"


@interface XPTopicViewModel ()

@property(nonatomic,strong,readwrite)NSArray *forumTopic;
@property(nonatomic,strong,readwrite)RACCommand *topicCommand;

@end

@implementation XPTopicViewModel

-(RACCommand *)topicCommand
{
    if (!_topicCommand) {
        @weakify(self);
        _topicCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            return [self.apiManager forumTopic];
        }];
        [[_topicCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            self.forumTopic = x;
        }];
        XPViewModelShortHand(_topicCommand)
    }
    return _topicCommand;
}

@end 
