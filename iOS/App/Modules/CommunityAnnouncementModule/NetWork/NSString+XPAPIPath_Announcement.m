//
//  NSString+XPAPIPath_Announcement.m
//  XPApp
//
//  Created by iiseeuu on 15/12/18.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "NSString+XPAPIPath.h"
#import "NSString+XPAPIPath_Announcement.h"

@implementation NSString (XPAPIPath_Announcement)

+ (NSString *)api_announcement_path
{
    return [@"/api/v1/community_announcements" fillBaseAPIPath];
}

@end
