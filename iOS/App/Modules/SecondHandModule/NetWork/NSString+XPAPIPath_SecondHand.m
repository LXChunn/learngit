//
//  NSString+XPAPIPath_SecondHand.m
//  XPApp
//
//  Created by jy on 15/12/29.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "NSString+XPAPIPath.h"
#import "NSString+XPAPIPath_SecondHand.h"

@implementation NSString (XPAPIPath_SecondHand)

+ (NSString *)api_secondhand_items_path
{
    return [@"/api/v1/secondhand_items" fillBaseAPIPath];
}

+ (NSString *)api_secondhand_item_create_path
{
    return [@"/api/v1/secondhand_item/create" fillBaseAPIPath];
}

+ (NSString *)api_secondhand_item_detail_path
{
    return [@"/api/v1/secondhand_item" fillBaseAPIPath];
}

+ (NSString *)api_secondhand_item_cancel_path
{
    return [@"/api/v1/secondhand_item/cancel" fillBaseAPIPath];
}

+ (NSString *)api_secondhand_item_close_path
{
    return [@"/api/v1/secondhand_item/close" fillBaseAPIPath];
}

+ (NSString *)api_secondhand_comment_create_path
{
    return [@"/api/v1/secondhand_comment/create" fillBaseAPIPath];
}

+ (NSString *)api_secondhand_comment_delete_path
{
    return [@"/api/v1/secondhand_comment/delete" fillBaseAPIPath];
}

+ (NSString *)api_secondhand_comments_path
{
    return [@"/api/v1/secondhand_comments" fillBaseAPIPath];
}

+ (NSString *)api_collection_favorite_create
{
    return [@"/api/v1/favorite/create" fillBaseAPIPath];
}

@end
