//
//  XPAPIManager+HappyLife.h
//  XPApp
//
//  Created by jy on 16/1/13.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager.h"

typedef enum : NSUInteger {
    BillTypeOfLifeService,
    BillTypeOfEntertainmentTravel,
    BillTypeOfFinancialService,
    BillTypeOfPay,
    BillTypeOfEduication,
    BillTypeOfMedical,
} BillType;

@interface XPAPIManager (HappyLife)

- (RACSignal *)happyLifeWithDate:(NSString *)date time:(NSString *)time billType:(BillType)billType cityCode:(NSString *)cityCode;

@end
