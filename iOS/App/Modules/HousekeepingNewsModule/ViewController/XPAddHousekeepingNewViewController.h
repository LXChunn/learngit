//
//  XPAddHousekeepingNewViewController.h
//  XPApp
//
//  Created by jy on 16/2/22.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewController.h"
#import "XPAddHousekeepingModel.h"

@interface XPAddHousekeepingNewViewController : XPBaseViewController
@property (nonatomic,strong) XPAddHousekeepingModel *housekeepingModel;
@property (nonatomic,strong) NSString *housekeepingItemId;
@property (nonatomic,assign) BOOL isChange;
@end
