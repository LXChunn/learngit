//
//  XPPostHousekeepingViewModel.m
//  XPApp
//
//  Created by jy on 16/2/22.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPPostHousekeepingViewModel.h"
#import "XPAPIManager+HousekeepingNews.h"

@interface XPPostHousekeepingViewModel ()
@property (nonatomic, strong, readwrite) RACCommand *postCommand;
@property (nonatomic, strong, readwrite) RACCommand *updateCommand;
@property (nonatomic, strong, readwrite) NSString *successMessage;

@end

@implementation XPPostHousekeepingViewModel

- (instancetype)init {
	if (self = [super init]) {

	}
	return self;
}

- (RACCommand *)postCommand
{
    if(!_postCommand) {
        @weakify(self);
        _postCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager createHousekeepingWithTitle:_model.title content:_model.content picUrls:_model.pictureUrls mobile:_model.phone];
        }];
        [[_postCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            self.successMessage = x;
        }];
        XPViewModelShortHand(_postCommand)
    }
    return _postCommand;
}

- (RACCommand *)updateCommand
{
    if(!_updateCommand) {
        @weakify(self);
        _updateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager updateHousekeepingWithTitle:_model.title content:_model.content picUrls:_model.pictureUrls mobile:_model.phone housekeepingItemId:_housekeepingItemId];
        }];
        [[_updateCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            self.successMessage = x;
        }];
        XPViewModelShortHand(_updateCommand)
    }
    return _updateCommand;
}


@end 
