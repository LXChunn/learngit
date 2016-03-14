//
//  XPMyMaintenanceModel.h
//  XPApp
//
//  Created by iiseeuu on 15/12/25.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"

@interface XPMyMaintenanceModel : XPBaseModel

@property NSString *content;
@property NSString *createdAt;
@property NSString *maintenanceOrderId;
@property NSArray *picUrls;
@property NSString *status;
@property NSString *type;

@end
