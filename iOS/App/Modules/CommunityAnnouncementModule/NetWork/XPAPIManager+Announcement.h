//
//  XPAPIManager+Announcement.h
//  XPApp
//
//  Created by iiseeuu on 15/12/18.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager.h"

@interface XPAPIManager (Announcement)

/*
 查询社区公告列表
 */
- (RACSignal *)announcementList;

@end
