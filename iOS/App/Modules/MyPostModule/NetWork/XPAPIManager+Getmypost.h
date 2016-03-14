//
//  XPAPIManager+Getmypost.h
//  XPApp
//
//  Created by CaoShunQing on 16/1/8.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager.h"

@interface XPAPIManager (Getmypost)

- (RACSignal *)getMyForumtopicsWithPageSize:(NSInteger)num lasttopicid:(NSString *)lasttopicId;

- (RACSignal *)getMyForumSecondHandtopicsWithPageSize:(NSInteger)num lastitemid:(NSString *)lastitemId;

- (RACSignal *)getOtherForm:(NSString *)lastItemid;

- (RACSignal *)getMyCarpoolDetail:(NSString *)lastItemId;
@end
