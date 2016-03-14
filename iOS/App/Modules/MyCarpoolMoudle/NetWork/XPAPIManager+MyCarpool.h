//
//  XPAPIManager+Carpool.h
//  XPApp
//
//  Created by CaoShunQing on 16/2/23.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager.h"

@interface XPAPIManager (MyCarpool)


- (RACSignal *)getMyCarpool:(NSString *)lastCarpoolItemid;

@end
