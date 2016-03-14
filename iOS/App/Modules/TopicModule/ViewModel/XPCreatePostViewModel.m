//
//  XPCreatePostViewModel.m
//  XPApp
//
//  Created by iiseeuu on 15/12/30.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+CreatePost.h"
#import "XPCreatePostViewModel.h"

@interface XPCreatePostViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *createCommand;
@property (nonatomic, strong, readwrite) RACCommand *updateCommand;
@property (nonatomic, strong, readwrite) NSString *successMessage;
@end

@implementation XPCreatePostViewModel

- (instancetype)init
{
    if(self = [super init]) {
    }
    
    return self;
}

#pragma mark - Getter && Setter
- (RACCommand *)createCommand
{
    if(!_createCommand) {
        @weakify(self);
        _createCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager createPostWithTitle:self.model.goodsTitle type:self.type content:self.model.goodsDescriptions picUrls:self.model.pictures];//传参
        }];
        [[[_createCommand executionSignals] concat] subscribeNext:^(id x) {
            @strongify(self);
            self.successMessage = x;
        }];
        XPViewModelShortHand(_createCommand)
    }
    
    return _createCommand;
}

- (RACCommand *)updateCommand
{
    if(!_updateCommand) {
        @weakify(self);
        _updateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager updatePostWithForumtopicId:self.forumtopicId title:self.model.goodsTitle content:self.model.goodsDescriptions picUrls:self.model.pictures];//传参
        }];
        [[[_updateCommand executionSignals] concat] subscribeNext:^(id x) {
            @strongify(self);
            self.successMessage = x;
        }];
        XPViewModelShortHand(_updateCommand)
    }
    
    return _updateCommand;
}

@end
