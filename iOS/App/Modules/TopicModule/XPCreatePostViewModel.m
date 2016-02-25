//
//  XPCreatePostViewModel.m
//  XPApp
//
//  Created by iiseeuu on 15/12/30.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPCreatePostViewModel.h"
#import "XPAPIManager+CreatePost.h"

@interface XPCreatePostViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *createpostCommand;
@property (nonatomic, strong) RACSignal *validSignal;
@property (nonatomic,strong, readwrite) NSString *successMsg;

@end

@implementation XPCreatePostViewModel

- (instancetype)init {
	if (self = [super init]) {
        self.type = nil;
        self.title = nil;
        self.content = nil;
        self.startdate = nil;
	}
	return self;
}


#pragma mark - Getter && Setter

- (RACSignal *)validSignal
{
//    return [RACSignal combineLatest:@[RACObserve(self, title), RACObserve(self, content),RACObserve(self, type),RACObserve(self, startdate)] reduce:^id (NSString *type, NSString *content,NSString *title,NSString *startdate){
//        return @(type && (content.length >= 10 && content.length <= 2000)&&(title.length >= 1 && title.length <= 20 )&&startdate);
//    }];
    
    return [RACSignal combineLatest:@[RACObserve(self, title), RACObserve(self, content)] reduce:^id ( NSString *content,NSString *title){
        return @((content.length >= 10 && content.length <= 2000)&&(title.length >= 1 && title.length <= 20 ));
    }];
    
    
}

- (RACCommand *)createpostCommand
{
    if(!_createpostCommand) {
        @weakify(self);
        _createpostCommand = [[RACCommand alloc] initWithEnabled:self.validSignal signalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager createPostWithTitle:self.title withType:self.type withContent:self.content withStartdate:self.startdate withPicUrls:self.picUrls];//传参
        }];
        [[[_createpostCommand executionSignals] concat] subscribeNext:^(id x) {
            @strongify(self);
            self.createpostFinished = YES;
            self.successMsg = x;
        }];
        XPViewModelShortHand(_createpostCommand)
    }
    return _createpostCommand;
}

@end 
