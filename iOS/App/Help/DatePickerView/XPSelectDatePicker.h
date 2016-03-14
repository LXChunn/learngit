//
//  XPSelectDatePicker.h
//  XPApp
//
//  Created by jy on 15/12/11.
//  Copyright © 2015年 iiseeuu.com. All rights reserved.
//

#import "XPDatePickerView.h"
#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SelectDateTypeDefault = 0,
    SelectDateTypeOfBefore = 1,
    SelectDateTypeOfAfter = 2,
} SelectDateType;

typedef void (^DateSelectBlock)(NSDate *date
                                );

@interface XPSelectDatePicker : NSObject

/**
 *  UI加载
 *
 *  @param dateType            UI类型
 *  @param selectDateType      时间选择的类型，能否选择当前时间 之前或之后的时间
 *  @param selectDateTimeBlock 日期使用selectDate的数据，时间使用selectTime的数据
 */
- (void)loadPickerWithselectDateType:(SelectDateType)selectDateType
                    finishSelectDate:(DateSelectBlock)selectDateTimeBlock;

@end
