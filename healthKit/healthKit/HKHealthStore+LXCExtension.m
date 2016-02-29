//
//  HKHealthStore+LXCExtension.m
//  healthKit
//
//  Created by 刘小椿 on 16/2/27.
//  Copyright © 2016年 刘小椿. All rights reserved.
//

#import "HKHealthStore+LXCExtension.h"

@implementation HKHealthStore (LXCExtension)
-(void)aapl_mostRecentQuantitySampleOfType:(HKQuantityType *)quantityType predicate:(NSPredicate *)predicate completion:(void (^)(HKQuantity *, NSError *))completion
{
    NSSortDescriptor* timeSortDescriptor = [[NSSortDescriptor alloc]initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    
    HKSampleQuery* query = [[HKSampleQuery alloc]initWithSampleType:quantityType predicate:predicate limit:1 sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        if (!results) {
            if (completion) {
                completion(nil,error);
            }
            return;
        }
        if (completion) {
            HKQuantitySample* quantitySample = results.firstObject;
            HKQuantity* quantity = quantitySample.quantity; 
            
            completion(quantity,error);
        }
        
    }];
    
    [self executeQuery:query];
}


@end
