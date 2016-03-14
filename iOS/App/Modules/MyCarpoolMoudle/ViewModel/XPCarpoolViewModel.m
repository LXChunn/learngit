//
//  XPCarpoolViewModel.m
//  XPApp
//
//  Created by CaoShunQing on 16/2/23.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPCarpoolViewModel.h"
#import "XPAPIManager+MyCarpool.h"
#import "XPMyCarpoolModel.h"

@interface XPCarpoolViewModel ()
@property (nonatomic ,strong, readwrite)RACCommand *myCarpoolCommand;
@property (nonatomic ,strong, readwrite)RACCommand *moreCarpoolCommand;
@property (nonatomic ,strong, readwrite)NSString *lastItemId;
@property (nonatomic ,strong, readwrite)NSArray *myCarpoolArray;
@property (nonatomic ,assign, readwrite)BOOL isNoMoreData;

@end

@implementation XPCarpoolViewModel

- (instancetype)init {
	if (self = [super init]) {
        self.lastItemId = nil;
	}
	return self;
}

- (RACCommand *)myCarpoolCommand
{
    if(!_myCarpoolCommand) {
        @weakify(self);
        _myCarpoolCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager getMyCarpool:nil];
        }];
        [[_myCarpoolCommand.executionSignals concat] subscribeNext:^(NSArray *x) {
            @strongify(self);
            if ([x count]) {
                XPMyCarpoolModel *model = [x lastObject];
                self.lastItemId = model.carpoolingItemId;
            }
            self.myCarpoolArray = x;
            if (x.count < 20) {
                self.isNoMoreData = YES;
            }
        }];
        XPViewModelShortHand(_myCarpoolCommand)
    }
    return _myCarpoolCommand;
}

- (RACCommand *)moreCarpoolCommand
{
    if(!_moreCarpoolCommand) {
        @weakify(self);
        _moreCarpoolCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager getMyCarpool:self.lastItemId];
        }];
        [[[_moreCarpoolCommand executionSignals] concat] subscribeNext:^(NSArray *x) {
            @strongify(self);
            if(x.count > 0) {
                XPMyCarpoolModel *model = [x lastObject];
                self.lastItemId = model.carpoolingItemId;
            }
            if (self.myCarpoolArray) {
                self.myCarpoolArray = [self.myCarpoolArray arrayByAddingObjectsFromArray:x];
            }else{
                self.myCarpoolArray = x;
            }
            if (x.count < 20) {
                self.isNoMoreData = YES;
            }
        }];
        XPViewModelShortHand(_moreCarpoolCommand)
    }
    return _moreCarpoolCommand;
}

@end 
