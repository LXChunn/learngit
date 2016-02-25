//
//  XPAPIManager+Announcement.h
//  XPApp
//
//  Created by iiseeuu on 15/12/18.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager.h"

@interface XPAPIManager (PropertyBill)

/*
 代缴账单列表
 */
- (RACSignal *)propertyBillList;

@end
