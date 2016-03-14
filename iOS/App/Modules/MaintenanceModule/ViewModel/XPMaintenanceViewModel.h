//
//  XPMaintenanceViewModel.h
//  XPApp
//
//  Created by iiseeuu on 15/12/23.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"

#import "XPMyMaintenanceModel.h"

@interface XPMaintenanceViewModel : XPBaseViewModel

#pragma mark - 发布
@property (nonatomic, strong, readonly) RACCommand *submitCommand;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSArray *picUrls;
@property (nonatomic, strong) NSString *successMessage;
@property (nonatomic, strong) XPMyMaintenanceModel *model;

#pragma mark - 列表
@property (nonatomic, strong, readonly) NSArray *orders;
@property (nonatomic, strong, readonly) RACCommand *orderCommand;
@property (nonatomic, strong, readonly) RACCommand *moreOrderCommand;
@property (nonatomic, strong) NSString *maintenanceOrderId;
@property (nonatomic, assign, readonly) BOOL isNoMoreDate;


#pragma mark - 详情
@property (nonatomic, strong, readonly) RACCommand *cancelCommand;
@property (nonatomic, strong, readonly) RACCommand *confirmCommand;
@property (nonatomic, strong) NSString *maintenanceorderId;
@property (nonatomic, assign, readonly) BOOL isCancelSuccess;
@property (nonatomic, assign, readonly) BOOL isConfirmSuccess;

@end
