//
//  NSString+XPAPIPath_Vote.h
//  XPApp
//
//  Created by Mac OS on 15/12/31.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XPAPIPath_Vote)

+ (NSString *)api_vote_path;

+ (NSString *)api_releasvote_path;

+ (NSString *)api_from_topic_vote_path;

+ (NSString *)api_forum_comments_path;

+ (NSString *)api_forum_comment_create_path;

@end
