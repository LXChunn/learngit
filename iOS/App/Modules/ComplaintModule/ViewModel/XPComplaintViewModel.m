//
//  XPComplaintViewModel.m
//  XPApp
//
//  Created by Mac OS on 15/12/24.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+Complaint.h"
#import "XPComplaintModel.h"
#import "XPComplaintViewModel.h"

@interface XPComplaintViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *complaintCommand;
@property (nonatomic, strong) RACSignal *validSignal;
@property (nonatomic, strong, readwrite) NSArray *list;
@property (nonatomic, strong, readwrite) RACCommand *orderCommand;
@property (nonatomic, strong, readwrite) RACCommand *moreOrderCommand;
@property (nonatomic, strong, readwrite) RACCommand *cancelCommand;
@property (nonatomic, strong, readwrite) RACCommand *confirmCommand;
@property (nonatomic, assign, readwrite) BOOL isCancelSuccess;
@property (nonatomic, assign, readwrite) BOOL isConfirmSuccess;
@property (nonatomic, strong, readwrite) NSString *successMsg;
@property (nonatomic, assign, readwrite) BOOL isNoMoreDate;

@end

@implementation XPComplaintViewModel

- (instancetype)init
{
    if((self = [super init])) {
        self.picUrls = nil;
        self.content = nil;
        self.isNoMoreDate = NO;
    }
    return self;
}

#pragma mark - Getter && Setter

- (RACCommand *)complaintCommand
{
    if(!_complaintCommand) {
        @weakify(self);
        _complaintCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager maintenanceWithContent:self.content withPicUrls:self.picUrls];
        }];
        [[[_complaintCommand executionSignals] concat] subscribeNext:^(id x) {
            @strongify(self);
            self.submitFinished = YES;
            self.successMsg = x;
        }];
        XPViewModelShortHand(_complaintCommand)
    }
    
    return _complaintCommand;
}

- (RACCommand *)orderCommand
{
    if(!_orderCommand) {
        @weakify(self);
        _orderCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager listComplaitWithComplaintId:nil];
        }];
        [[_orderCommand.executionSignals concat] subscribeNext:^(NSArray*x) {
            @strongify(self);

            if( x.count > 0) {
                XPComplaintModel *model = [x lastObject];
                self.lastComplaintId = model.complaintId;
            }
            self.list = x;
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
            return [self.apiManager listComplaitWithComplaintId:self.lastComplaintId];
        }];
        [[_moreOrderCommand.executionSignals concat] subscribeNext:^(NSArray* x) {
            @strongify(self);
            if(x.count > 0) {
                XPComplaintModel *model = [x lastObject];
                self.lastComplaintId = model.complaintId;
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
            return [self.apiManager cancelComplaintWithId:self.complaintId];
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
            return [self.apiManager confirmComplaintWithId:self.complaintId];
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
