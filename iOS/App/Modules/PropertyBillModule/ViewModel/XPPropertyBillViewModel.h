//
//  XPJFZDViewModel.h
//  XPApp
//
//  Created by Mac OS on 15/12/20.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"
#import "XPPropertyBillModel.h"

@interface XPPropertyBillViewModel : XPBaseViewModel

@property (nonatomic, strong, readonly) NSArray *list;
@property (nonatomic, strong, readonly) RACCommand *moreListCommand;
@property (nonatomic, strong, readonly) RACCommand *listCommand;
@property (nonatomic, strong, readonly) RACCommand *paymentCommand;
@property (nonatomic, strong, readonly) RACCommand *paymentResultCommand;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, assign, readonly) BOOL isNoMoreDate;
@property (nonatomic, strong) NSString *billId;
@property (nonatomic, strong, readonly) NSDictionary *paymentUrlDic;
@property (nonatomic, assign, readonly) BOOL isPaymentResult;


@end
