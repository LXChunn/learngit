//
//  XPIntegralExchangeViewModel.h
//  XPApp
//
//  Created by CaoShunQing on 16/2/24.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"


@interface XPIntegralExchangeViewModel : XPBaseViewModel

@property (nonatomic, strong, readonly)RACCommand *ExchangeCommand;
@property (nonatomic, strong, readonly)RACCommand *RecordExchangeCommand;
@property (nonatomic, strong, readonly)NSArray *listArray;
@property (nonatomic, assign) NSInteger point;
@property (nonatomic, assign, readonly)BOOL isSuccess;
@end
