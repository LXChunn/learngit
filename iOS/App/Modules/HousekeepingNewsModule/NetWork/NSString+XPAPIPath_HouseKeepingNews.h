//
//  NSString+XPAPIPath_HouseKeepingNews.h
//  XPApp
//
//  Created by jy on 16/2/22.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XPAPIPath_HouseKeepingNews)
+ (NSString *)api_housekeepings_list_path;

+ (NSString *)api_housekeepings_create_path;

+ (NSString *)api_housekeepings_update_path;

+ (NSString *)api_housekeepings_delete_path;

+ (NSString *)api_housekeepings_detail_path;

+ (NSString *)api_housekeepings_comments_path;

+ (NSString *)api_housekeepings_comment_create_path;
@end
