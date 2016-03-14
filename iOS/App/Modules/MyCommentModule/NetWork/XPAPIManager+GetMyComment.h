//
//  XPAPIManager+GetMyComment.h
//  XPApp
//
//  Created by CaoShunQing on 16/1/8.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager.h"

@interface XPAPIManager (GetMyComment)

- (RACSignal *)getMyCommentsWithType:(NSString *)type pageSize:(NSInteger)pageSize lastCommentid:(NSString *)lastCommentId;

@end
