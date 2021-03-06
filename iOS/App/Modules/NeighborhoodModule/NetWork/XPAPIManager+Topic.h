//
//  XPAPIManager+Topic.h
//  XPApp
//
//  Created by iiseeuu on 15/12/28.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager.h"

@interface XPAPIManager (Topic)

- (RACSignal *)forumTopicWithLastTopicId:(NSString *)lastTopicId;
- (RACSignal *)forumTopic;
- (RACSignal *)forumParticipation;
@end
