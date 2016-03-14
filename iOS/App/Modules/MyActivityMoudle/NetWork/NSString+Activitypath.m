//
//  NSString+Activitypath.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/7.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "NSString+Activitypath.h"
#import "NSString+XPAPIPath.h"
@implementation NSString (Activitypath)

+ (NSString *)api_my_participation
{
    return [@"/api/v1/my_participation" fillBaseAPIPath];
}

@end
