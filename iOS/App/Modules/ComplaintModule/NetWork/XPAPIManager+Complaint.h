//
//  XPAPIManager+Complaint.h
//  XPApp
//
//  Created by jy on 16/2/3.
//  Copyright 2016年 ShareMerge. All rights reserved.
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
- (RACSignal *)listComplaitWithComplaintId:(NSString *)complaintId;

/**
 *  取消投诉
 *
 *  @param complaintId 投诉单ID
 *
 *  @return
 */
- (RACSignal *)cancelComplaintWithId:(NSString *)complaintId;

/**
 *  确认投诉已经解决
 *
 *  @param complaintId 投诉单ID
 *
 *  @return
 */
- (RACSignal *)confirmComplaintWithId:(NSString *)complaintId;


@end
