//
//  XPAPIManager+BankAdvertisements.h
//  XPApp
//
//  Created by iiseeuu on 16/1/12.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager.h"

@interface XPAPIManager (BankAdvertisements)


/**
 银行公告
 */
- (RACSignal *)bankAdvertisementsList;

@end
