//
//  XPAPIManager+Getmycollect.h
//  XPApp
//
//  Created by CaoShunQing on 16/1/8.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager.h"

@interface XPAPIManager (Getmycollect)

- (RACSignal *)getMyFavoriteWithType:(NSString *)type pagerSize:(NSInteger)pagesize lastItemId:(NSString *)lid;

@end
