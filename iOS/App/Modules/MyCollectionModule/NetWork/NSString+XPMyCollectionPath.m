//
//  NSString+XPMyCollectionPath.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/8.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "NSString+XPAPIPath.h"
#import "NSString+XPMyCollectionPath.h"

@implementation NSString (XPMyCollectionPath)

+ (NSString *)api_my_favorites
{
    return [@"/api/v1/favorites" fillBaseAPIPath];
}

+ (NSString *)api_my_otherFavorites
{
    return [@"" fillBaseAPIPath];
}

@end
