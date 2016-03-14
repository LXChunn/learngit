//
//  NSString+XPAPIPath_SecondHand.h
//  XPApp
//
//  Created by jy on 15/12/29.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XPAPIPath_SecondHand)

+ (NSString *)api_secondhand_items_path;

+ (NSString *)api_secondhand_item_create_path;

+ (NSString *)api_secondhand_item_detail_path;

+ (NSString *)api_secondhand_item_cancel_path;

+ (NSString *)api_secondhand_item_close_path;

+ (NSString *)api_secondhand_comment_create_path;

+ (NSString *)api_secondhand_comment_delete_path;

+ (NSString *)api_secondhand_comments_path;

+ (NSString *)api_collection_favorite_create_path;

+ (NSString *)api_secondhand_item_update_path;

+ (NSString *)api_collection_favorite_cancel_path;

@end
