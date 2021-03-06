//
//  NSString+XPAPIPath_CreatePost.h
//  XPApp
//
//  Created by iiseeuu on 15/12/30.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XPAPIPath_CreatePost)

+ (NSString *)api_createpost_path;//发布帖子

+ (NSString *)api_detailpost_path;//帖子详情

+ (NSString *)api_update_path;//编辑帖子

+ (NSString *)api_delete_path;//删除帖子

+ (NSString *)api_close_vote_path;//关闭投票

@end
