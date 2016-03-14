//
//  XPJFZDViewModel.m
//  XPApp
//
//  Created by Mac OS on 15/12/20.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+PropertyBill.h"
#import "XPPropertyBillViewModel.h"

@interface XPPropertyBillViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *listCommand;
@property (nonatomic, strong, readwrite) RACCommand *moreListCommand;
@property (nonatomic, strong, readwrite) NSString *lastBillId;
@property (nonatomic, strong, readwrite) NSArray *list;
@property (nonatomic, assign, readwrite) BOOL isNoMoreDate;
@property (nonatomic, strong, readwrite) RACCommand *paymentCommand;
@property (nonatomic, strong, readwrite) RACCommand *paymentResultCommand;
@property (nonatomic, strong, readwrite) NSDictionary *paymentUrlDic;
@property (nonatomic, assign, readwrite) BOOL isPaymentResult;

@end

@implementation XPPropertyBillViewModel

- (RACCommand *)listCommand
{
    if(!_listCommand) {
        @weakify(self);
        _listCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager propertyBillListWithStatus:self.status lastBillId:nil];
        }];
        [[_listCommand.executionSignals concat] subscribeNext:^(NSArray * x) {
            @strongify(self);
            
            if(x.count > 0) {
                XPPropertyBillModel *model = [x lastObject];
                self.lastBillId = model.billId;
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

- (RACCommand *)moreListCommand
{
    if(!_moreListCommand) {
        @weakify(self);
        _moreListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager propertyBillListWithStatus:self.status lastBillId:self.lastBillId];
        }];
        [[_moreListCommand.executionSignals concat] subscribeNext:^(NSArray * x) {
            @strongify(self);
            if(x.count > 0) {
                XPPropertyBillModel *model = [x lastObject];
                self.lastBillId = model.billId;
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
        XPViewModelShortHand(_moreListCommand)
    }
    return _moreListCommand;
}

- (RACCommand *)paymentCommand{
    if(!_paymentCommand) {
        @weakify(self);
        _paymentCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager propertyBillPaymentUrlBillId:_billId];
        }];
        [[_paymentCommand.executionSignals concat] subscribeNext:^(NSDictionary * x) {
            @strongify(self);
            self.paymentUrlDic = x;
        }];
        XPViewModelShortHand(_paymentCommand)
    }
    return _paymentCommand;
}

- (RACCommand *)paymentResultCommand{
    if(!_paymentResultCommand) {
        @weakify(self);
        _paymentResultCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.apiManager propertyBillPaymentResultWithBillId:_billId];
        }];
        [[_paymentResultCommand.executionSignals concat] subscribeNext:^(NSDictionary * x) {
            @strongify(self);
            NSNumber * result = x[@"bill_payment_result"];
    
            if ([result intValue] == 0) {
                self.isPaymentResult = NO;
            }else if([result intValue] == 1){
                self.isPaymentResult = YES;
            }
        }];
        XPViewModelShortHand(_paymentResultCommand)
    }
    return _paymentResultCommand;
}


@end
