//
//  XPAPIManager+Setting.h
//  XPApp
//
//  Created by CaoShunQing on 16/1/12.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager.h"

@interface XPAPIManager (Setting)

- (RACSignal *)sendSuggestionWithPhoneType:(NSString *)type content:(NSString *)content version:(NSInteger)version;

@end
