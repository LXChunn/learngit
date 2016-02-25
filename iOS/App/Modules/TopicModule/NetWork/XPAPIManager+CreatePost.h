//
//  XPAPIManager+CreatePost.h
//  XPApp
//
//  Created by iiseeuu on 15/12/30.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager.h"

@interface XPAPIManager (CreatePost)


- (RACSignal *)createPostWithTitle:(NSString *)title withType:(NSString *)type withContent:(NSString *)content withStartdate:(NSString *)startdate withPicUrls:(NSArray *)picUrls;



- (RACSignal *)detailPostWithForumtopicid:(NSString *)forumtopicId;


@end
