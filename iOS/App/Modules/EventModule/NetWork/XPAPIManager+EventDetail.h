//
//  XPAPIManager+EventDetail.h
//  XPApp
//
//  Created by jy on 16/1/9.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager.h"

@interface XPAPIManager (EventDetail)

- (RACSignal *)eventDetailWithForumtopicid:(NSString *)forumtopicId;

- (RACSignal *)joinEventWithForumtopicid:(NSString *)forumtopicId;
@end
