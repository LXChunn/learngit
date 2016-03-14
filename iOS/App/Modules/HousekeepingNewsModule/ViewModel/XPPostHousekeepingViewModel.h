//
//  XPPostHousekeepingViewModel.h
//  XPApp
//
//  Created by jy on 16/2/22.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"
#import "XPAddHousekeepingModel.h"

@interface XPPostHousekeepingViewModel : XPBaseViewModel
@property (nonatomic, strong, readonly) RACCommand *postCommand;
@property (nonatomic, strong, readonly) RACCommand *updateCommand;
@property (nonatomic, strong) XPAddHousekeepingModel *model;
@property (nonatomic, strong) NSString *housekeepingItemId;
@property (nonatomic, strong, readonly) NSString *successMessage;

@end
