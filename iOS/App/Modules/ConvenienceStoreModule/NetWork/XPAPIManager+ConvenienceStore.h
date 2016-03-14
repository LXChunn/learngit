//
//  XPAPIManager+ConvenienceStore.h
//  XPApp
//
//  Created by iiseeuu on 16/1/15.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager.h"

@interface XPAPIManager (ConvenienceStore)
/**
 *  社区便利店
 *
 *  @param LastItemId 上页最后一条商品的ID
 *
 *  @return
 */
- (RACSignal *)convenienceStoreListWithLastItemId:(NSString *)lastItemId;

@end
