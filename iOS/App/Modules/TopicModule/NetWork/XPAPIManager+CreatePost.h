//
//  XPAPIManager+CreatePost.h
//  XPApp
//
//  Created by iiseeuu on 15/12/30.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager.h"

@interface XPAPIManager (CreatePost)

- (RACSignal *)createPostWithTitle:(NSString *)title type:(NSString *)type content:(NSString *)content picUrls:(NSArray *)picUrls;

- (RACSignal *)createEventPostWithTitle:(NSString *)title type:(NSString *)type content:(NSString *)content picUrls:(NSArray *)picUrls startDate:(NSString *)startDate endDate:(NSString *)endDate;

- (RACSignal *)detailPostWithForumtopicid:(NSString *)forumtopicId;

- (RACSignal *)updatePostWithForumtopicId:(NSString *)forumtopicId title:(NSString *)title content:(NSString *)content picUrls:(NSArray *)picUrls;

- (RACSignal *)deletePostWithForumtopicid:(NSString *)forumtopicId;

- (RACSignal *)closeVoteWithFormtopicId:(NSString *)forumtopicId;

@end
