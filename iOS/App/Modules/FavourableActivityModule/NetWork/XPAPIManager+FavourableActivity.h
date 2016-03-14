//
//  XPAPIManager+FavourableActivity.h
//  XPApp
//
//  Created by CaoShunQing on 16/1/18.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager.h"

@interface XPAPIManager (FavourableActivity)

- (RACSignal *)getFavourableActivitys:(NSString *)lastCcbactivityId;

@end
