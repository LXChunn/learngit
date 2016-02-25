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

- (RACSignal *)myMaintenance;

@end
