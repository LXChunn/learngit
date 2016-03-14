//
//  XPFavourActivityViewModel.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/18.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPFavourActivityViewModel.h"
#import "XPAPIManager+FavourableActivity.h"
#import "XPCcbActivitiesModel.h"

@interface XPFavourActivityViewModel ()
@property (nonatomic,strong,readwrite)RACCommand *activityCommand;
@property (nonatomic,strong,readwrite)RACCommand *activityMoreCommand;
@property (nonatomic,strong,readwrite)NSString *sucessMessage;
@property (nonatomic,strong,readwrite)NSArray *activityArray;
@property (nonatomic,strong,readwrite)NSString *lastId;
@property (nonatomic,assign,readwrite)BOOL isNoMoreDate;

@end

@implementation XPFavourActivityViewModel

- (instancetype)init {
	if (self = [super init]) {
        self.lastId = nil;
        self.isNoMoreDate = YES;
	}
	return self;
}

- (RACCommand *)activityCommand
{
    if(!_activityCommand) {
        @weakify(self);
        _activityCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager getFavourableActivitys:nil];
        }];
        [[_activityCommand.executionSignals concat] subscribeNext:^(NSArray *x) {
            @strongify(self);
            if(x.count > 0) {
                XPCcbActivitiesModel *model = [x lastObject];
                self.lastId = model.ccbActivityId;
            }
            self.activityArray = x;
            if (x.count < 20) {
                self.isNoMoreDate = YES;
            }
        }];
        XPViewModelShortHand(_activityCommand)
    }
    return _activityCommand;
}

- (RACCommand *)activityMoreCommand
{
    if(!_activityMoreCommand) {
        @weakify(self);
        _activityMoreCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            return [self.apiManager getFavourableActivitys:self.lastId];
        }];
        [[_activityMoreCommand.executionSignals concat] subscribeNext:^(NSArray * x) {
            @strongify(self);
            if(x.count > 0) {
                XPCcbActivitiesModel *model = [x lastObject];
                self.lastId = model.ccbActivityId;
            }
            if (self.activityArray) {
                self.activityArray = [self.activityArray arrayByAddingObjectsFromArray:x];
            }else{
                self.activityArray = x;
            }
            if (x.count < 20) {
                self.isNoMoreDate = YES;
            }
        }];
        XPViewModelShortHand(_activityMoreCommand)
    }
    
    return _activityMoreCommand;
}

@end 
