//
//  XPComplaintViewModel.m
//  XPApp
//
//  Created by Mac OS on 15/12/24.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPComplaintViewModel.h"
#import "NSString+XPAPI_Complaint.h"

@interface XPComplaintViewModel()

@property(nonatomic, strong, readwrite)RACCommand *complaintCommand;
@property(nonatomic, strong)RACSignal *validSignal;
@property(nonatomic, strong, readwrite)NSArray *list;
@property(nonatomic, strong, readwrite)RACCommand *orderCommand;


@end

@implementation XPComplaintViewModel

- (instancetype)init
{
    if((self = [super init])) {
        self.picUrls = nil;
        self.content = nil;
    }
    
    return self;
}

#pragma mark - Getter && Setter

- (RACCommand *)complaintCommand
{
    if(!_complaintCommand) {
        @weakify(self);
        _complaintCommand = [[RACCommand alloc] initWithEnabled:self.validSignal signalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager maintenanceWithContent:self.content withPicUrls:self.picUrls];
        }];
        [[[_complaintCommand executionSignals] concat] subscribeNext:^(id x) {
            @strongify(self);
            self.submitFinished = YES;
        }];
        XPViewModelShortHand(_complaintCommand)
    }
    return _complaintCommand;
}

-(RACCommand *)orderCommand
{
    if(!_orderCommand) {
        @weakify(self);
        _orderCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager listComplait];
        }];
        [[_orderCommand.executionSignals concat] subscribeNext:^(id x) {
            @strongify(self);
            self.list = x;
        }];
        XPViewModelShortHand(_orderCommand)
    }
    
    return _orderCommand;
}

@end
