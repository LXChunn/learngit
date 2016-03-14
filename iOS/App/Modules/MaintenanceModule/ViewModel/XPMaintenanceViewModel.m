//
//  XPMaintenanceViewModel.m
//  XPApp
//
//  Created by iiseeuu on 15/12/23.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+Maintenance.h"
#import "XPMaintenanceViewModel.h"
#import "XPMyMaintenanceModel.h"

@interface XPMaintenanceViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *submitCommand;
@property (nonatomic, strong, readwrite) RACCommand *orderCommand;
@property (nonatomic, strong, readwrite) RACCommand *moreOrderCommand;
@property (nonatomic, strong, readwrite) NSArray *orders;
@property (nonatomic, strong, readwrite) RACCommand *cancelCommand;
@property (nonatomic, strong, readwrite) RACCommand *confirmCommand;
@property (nonatomic, assign, readwrite) BOOL isCancelSuccess;
@property (nonatomic, assign, readwrite) BOOL isConfirmSuccess;
@property (nonatomic, assign, readwrite) BOOL isNoMoreDate;


@end

@implementation XPMaintenanceViewModel

- (instancetype)init
{
    if((self = [super init])) {
        self.type = nil;
        self.picUrls = nil;
        self.content = nil;
        self.isNoMoreDate = NO;
    }
    
    return self;
}

#pragma mark - Getter && Setter

- (RACCommand *)submitCommand
{
    if(!_submitCommand) {
        @weakify(self);
        _submitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager maintenanceSubmitWithContent:self.content withType:self.type withPicUrls:self.picUrls];//传参
        }];
        [[[_submitCommand executionSignals] concat] subscribeNext:^(id x) {
            @strongify(self);
            self.successMessage = x;
        }];
        XPViewModelShortHand(_submitCommand)
    }
    return _submitCommand;
}

- (RACCommand *)orderCommand
{
    if(!_orderCommand) {
        @weakify(self);
        _orderCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager myMaintenanceWithMaintecanceOrderId:nil];
        }];
        [[_orderCommand.executionSignals concat] subscribeNext:^(NSArray * x) {
            @strongify(self);
            if(x.count > 0) {
                XPMyMaintenanceModel *model = [x lastObject];
                self.maintenanceOrderId = model.maintenanceOrderId;
            }
            self.orders = x;
            if (x.count < 20) {
                self.isNoMoreDate = YES;
            }
        }];
        XPViewModelShortHand(_orderCommand)
    }
    
    return _orderCommand;
}

- (RACCommand *)moreOrderCommand
{
    if(!_moreOrderCommand) {
        @weakify(self);
        _moreOrderCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager myMaintenanceWithMaintecanceOrderId:self.maintenanceOrderId];
        }];
        [[_moreOrderCommand.executionSignals concat] subscribeNext:^(NSArray * x) {
            @strongify(self);
            if(x.count > 0) {
                XPMyMaintenanceModel *model = [x lastObject];
                self.maintenanceOrderId = model.maintenanceOrderId;
            }
            if (self.orders) {
                self.orders = [self.orders arrayByAddingObjectsFromArray:x];
            }else{
                self.orders = x;
            }
            if (x.count < 20) {
                self.isNoMoreDate = YES;
            }
        }];
        XPViewModelShortHand(_moreOrderCommand)
    }
    
    return _moreOrderCommand;
}

- (RACCommand *)cancelCommand
{
    if(!_cancelCommand) {
        @weakify(self);
        _cancelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager cancelMaintenanceWithOrderId:self.maintenanceorderId];
        }];
        [[_cancelCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            if([x isEqualToString:@"success"]) {
                self.isCancelSuccess = YES;
            }
        }];
        XPViewModelShortHand(_cancelCommand)
    }
    
    return _cancelCommand;
}

- (RACCommand *)confirmCommand
{
    if(!_confirmCommand) {
        @weakify(self);
        _confirmCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager confirmMaintenanceWithOrderId:self.maintenanceorderId];
        }];
        [[_confirmCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            if([x isEqualToString:@"success"]) {
                self.isConfirmSuccess = YES;
            }
        }];
        XPViewModelShortHand(_confirmCommand)
    }
    
    return _confirmCommand;
}

@end
