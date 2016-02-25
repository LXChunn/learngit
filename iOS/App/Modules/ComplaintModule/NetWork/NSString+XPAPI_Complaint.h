//
//  XPAPIManager+Announcement.h
//  XPApp
//
//  Created by iiseeuu on 15/12/18.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager.h"

@interface XPAPIManager (Complaint)

/*
 物业投诉
 */
- (RACSignal *)maintenanceWithContent:(NSString *)content withPicUrls:(NSArray *)picUrls;
/*
 查询该用户所属房屋的物业投诉列表
 */
- (RACSignal *)listComplait;

@end
