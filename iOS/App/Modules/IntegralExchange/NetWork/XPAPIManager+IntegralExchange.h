//
//  XPAPIManager+IntegralExchange.h
//  XPApp
//
//  Created by CaoShunQing on 16/2/24.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager.h"

@interface XPAPIManager (IntegralExchange)


- (RACSignal *)MyPointsExchange:(NSInteger)point;

- (RACSignal *)MyrecordsPointsExchange;
@end
