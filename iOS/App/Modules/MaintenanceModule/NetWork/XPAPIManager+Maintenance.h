//
//  XPAPIManager+Maintenance.h
//  XPApp
//
//  Created by iiseeuu on 15/12/23.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager.h"

@interface XPAPIManager (Maintenance)

/*
 物业报修
 */

- (RACSignal *)maintenanceSubmitWithContent:(NSString *)content withType:(NSString *)type withPicUrls:(NSArray *)picUrls;
/**
 *  我的报修列表
 *
 *  @return
 */
- (RACSignal *)myMaintenanceWithMaintecanceOrderId:(NSString *)maintecanceOrderId;
/**
 *  取消报修
 *
 *  @param maintenanceorderId   报修单ID
 *
 *  @return
 */
- (RACSignal *)cancelMaintenanceWithOrderId:(NSString *)maintenanceorderId;
/**
 *  确认报修问题解决
 *
 *  @param maintenanceorderId 报修单ID
 *
 *  @return
 */
- (RACSignal *)confirmMaintenanceWithOrderId:(NSString *)maintenanceorderId;

@end
