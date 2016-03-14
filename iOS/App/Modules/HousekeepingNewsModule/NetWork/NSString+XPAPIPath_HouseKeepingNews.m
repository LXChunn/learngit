//
//  NSString+XPAPIPath_HouseKeepingNews.m
//  XPApp
//
//  Created by jy on 16/2/22.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "NSString+XPAPIPath.h"
#import "NSString+XPAPIPath_HouseKeepingNews.h"

@implementation NSString (XPAPIPath_HouseKeepingNews)

+ (NSString *)api_housekeepings_list_path{
    return [@"/api/v1/housekeepings" fillBaseAPIPath];
}

+ (NSString *)api_housekeepings_create_path{
    return [@"/api/v1/housekeeping/create" fillBaseAPIPath];
}

+ (NSString *)api_housekeepings_update_path{
    return [@"/api/v1/housekeeping/update" fillBaseAPIPath];
}

+ (NSString *)api_housekeepings_delete_path{
    return [@"/api/v1/housekeeping/delete" fillBaseAPIPath];
}

+ (NSString *)api_housekeepings_detail_path{
    return [@"/api/v1/housekeeping" fillBaseAPIPath];
}

+ (NSString *)api_housekeepings_comments_path{
    return [@"/api/v1/housekeeping_comments" fillBaseAPIPath];
}

+ (NSString *)api_housekeepings_comment_create_path{
    return [@"/api/v1/housekeeping_comment/create" fillBaseAPIPath];
}

@end 
