//
//  XPCarpoolingsViewModel.m
//  XPApp
//
//  Created by iiseeuu on 16/2/22.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPCarpoolingsViewModel.h"
#import "XPCarpoolModel.h"
#import "XPAPIManager+Carpool.h"
@interface XPCarpoolingsViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *listCommand;
@property (nonatomic, strong, readwrite) RACCommand *listMoreCommand;
@property (nonatomic, strong, readwrite) NSArray *list;
@property (nonatomic, assign, readwrite) BOOL isNoMoreDate;
@property (nonatomic, strong, readwrite) RACCommand *createCommand;
@property (nonatomic, strong, readwrite) RACCommand *deleteCommand;
@property (nonatomic, assign, readwrite) BOOL isDeleteSuccess;

@end

@implementation XPCarpoolingsViewModel

- (instancetype)init {
	if (self = [super init]) {
        self.isNoMoreDate = NO;
	}
	return self;
}

- (RACCommand *)listCommand
{
    if(!_listCommand) {
        @weakify(self);
        _listCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager carpoolListWithLastCarpoolingItemId:nil];
        }];
        [[_listCommand.executionSignals concat] subscribeNext:^(NSArray *x) {
            @strongify(self);
            if ([x count]) {
                XPCarpoolModel *model = [x lastObject];
                self.lastCarpoolingId = model.carpoolingItemId;
            }
            self.list = x;
            if (x.count < 20) {
                self.isNoMoreDate = YES;
            }
        }];
        XPViewModelShortHand(_listCommand)
    }
    return _listCommand;
}

- (RACCommand *)listMoreCommand
{
    if(!_listMoreCommand) {
        @weakify(self);
        _listMoreCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager carpoolListWithLastCarpoolingItemId:self.lastCarpoolingId];
        }];
        [[_listMoreCommand.executionSignals concat] subscribeNext:^(NSArray *x) {
            @strongify(self);
            if ([x count]) {
                XPCarpoolModel *model = [x lastObject];
                self.lastCarpoolingId = model.carpoolingItemId;
            }
            if (self.list) {
                self.list = [self.list arrayByAddingObjectsFromArray:x];
            } else {
                self.list = x;
            }
            if (x.count < 20) {
                self.isNoMoreDate = YES;
            }
        }];
        XPViewModelShortHand(_listMoreCommand)
    }
    return _listMoreCommand;
}

#pragma mark - Getter && Setter
-(RACCommand *)createCommand
{
    if(!_createCommand) {
        @weakify(self);
        _createCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager carpoolingCreateWithStartPoint:self.model.startPoint withEndPoint:self.model.endPoint withTime:self.model.time withRemark:self.model.remark withMobile:self.model.mobile];//传参
        }];
        [[[_createCommand executionSignals] concat] subscribeNext:^(id x) {
            @strongify(self);
            self.successMessage = x;
        }];
        XPViewModelShortHand(_createCommand)
    }
    return _createCommand;
}

-(RACCommand *)deleteCommand
{
    if(!_deleteCommand) {
        @weakify(self);
        _deleteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager deleteWithcarpoolCarpoolingItemId:self.carpoolingItemId];
        }];
        [[_deleteCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            if([x isEqualToString:@"success"]) {
                self.isDeleteSuccess = YES;
            }
        }];
        XPViewModelShortHand(_deleteCommand)
    }
    return _deleteCommand;
}

@end
