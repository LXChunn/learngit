//
//  XPAPIManager+Household.h
//  XPApp
//
//  Created by xinpinghuang on 12/15/15.
//  Copyright 2015 ShareMerge. All rights reserved.
//

#import "XPAPIManager.h"

@interface XPAPIManager (Household)

/**
 *  绑定房号
 *
 *  @param houseId 房号
 *
 *  @return 信号
 */
- (RACSignal *)bindHouseholdWithHouseId:(NSString *)houseId;

@end
