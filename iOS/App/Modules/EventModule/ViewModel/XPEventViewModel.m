//
//  XPEventViewModel.m
//  XPApp
//
//  Created by iiseeuu on 16/1/9.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+CreatePost.h"
#import "XPEventViewModel.h"

@interface XPEventViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *createCommand;
@property (nonatomic, strong, readwrite) NSString *successMsg;

@end

@implementation XPEventViewModel

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
            return [self.apiManager createEventPostWithTitle:self.model.title type:self.type content:self.model.content picUrls:self.model.picUrls startDate:self.model.beginDate endDate:self.model.endDate];//传参
        }];
        [[[_createCommand executionSignals] concat] subscribeNext:^(id x) {
            @strongify(self);
            self.successMsg = x;
        }];
        XPViewModelShortHand(_createCommand)
    }
    
    return _createCommand;
}

@end
