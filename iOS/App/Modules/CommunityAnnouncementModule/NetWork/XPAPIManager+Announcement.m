//
//  XPAPIManager+Announcement.m
//  XPApp
//
//  Created by iiseeuu on 15/12/18.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "NSDictionary+XPAPIUserInfo.h"
#import "NSDictionary+XPAPIVerifyKey.h"
#import "NSString+XPAPIPath_Announcement.h"
#import "XPAPIManager+Analysis.h"
#import "XPAPIManager+Announcement.h"
#import "XPAnnouncementModel.h"

@implementation XPAPIManager (Announcement)

- (RACSignal *)announcementList
{
    return [[[[[self rac_GET:[NSString api_announcement_path] parameters:[[@{}
                                                                               fillUserInfo] fillVerifyKeyInfo]] map:^id (id value) {
        return [self analysisRequest:value];
    }] flattenMap:^RACStream *(id value) {
        if([value isKindOfClass:[NSError class]]) {
            return [RACSignal error:value];
        }
        
        return [self rac_MappingForClass:[XPAnnouncementModel class] array:value[@"community_announcements"]];
    }] logError] replayLazily];
}

@end
