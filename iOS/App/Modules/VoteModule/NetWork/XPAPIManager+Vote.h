//
//  XPAPIManager+XPAPIManager+Vote.h
//  XPApp
//
//  Created by Mac OS on 15/12/30.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager.h"

@interface XPAPIManager (Vote)

-(RACSignal *)voteWithaccessToken:(NSString *)accessToken withtitle:(NSString *)title withcontent:(NSString *)content withtype:(NSString *)type withoptions:(NSArray *)options;

-(RACSignal *)voteWithaccessToken:(NSString *)accessToken withforumTopicId:(NSString *)forumTopicId;

@end
