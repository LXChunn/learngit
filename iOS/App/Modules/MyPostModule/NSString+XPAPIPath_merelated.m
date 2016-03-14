//
//  NSString+XPAPIPath_merelated.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/7.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "NSString+XPAPIPath_merelated.h"

@implementation NSString (XPAPIPath_merelated)

+ (NSString *)api_my_comments
{
   return @"/api/v1/my_forum_topics";
}

+ (NSString *)api_my_forum_topics
{
  return @"/api/v1/my_secondhand_items";
}

+ (NSString *)api_my_secondhand_items
{
  return @"/api/v1/my_comments";
}
@end
