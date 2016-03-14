//
//  NSString+XPAPIPath_Getpost.h
//  XPApp
//
//  Created by CaoShunQing on 16/1/8.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XPAPIPath_Getpost)

+ (NSString *)api_my_forum_topics;//查询我的发布

+ (NSString *)api_my_secondhand_items;//查询我发布的二手信息

+ (NSString *)api_my_other_post;//查询我发布的其他信息

+ (NSString *)api_my_carpooling;
@end
