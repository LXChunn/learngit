//
//  HKHealthStore+LXCExtension.h
//  healthKit
//
//  Created by Mac OS on 16/2/29.
//  Copyright © 2016年 刘小椿. All rights reserved.
//

#import <HealthKit/HealthKit.h>

@interface HKHealthStore (LXCExtension)
- (void)aapl_mostRecentQuantitySampleOfType:(HKQuantityType *)quantityType predicate:(NSPredicate *)predicate completion:(void (^)(HKQuantity *mostRecentQuantity, NSError *error))completion;
@end
