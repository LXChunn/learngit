//
//  XPComplaintViewModel.h
//  XPApp
//
//  Created by Mac OS on 15/12/24.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"
#import "XPComplaintModel.h"

@interface XPComplaintViewModel : XPBaseViewModel

#pragma mark - 投诉
@property (nonatomic, strong, readonly) RACCommand *complaintCommand;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSArray *picUrls;
@property (nonatomic, assign) BOOL submitFinished;
@property (nonatomic, strong, readonly) NSString *successMsg;
@property (nonatomic, strong) XPComplaintModel *model;
#pragma mark - 列表
@property (nonatomic, strong, readonly) NSArray *list;
@property (nonatomic, strong, readonly) RACCommand *orderCommand;
@property (nonatomic, strong, readonly) RACCommand *moreOrderCommand;
@property (nonatomic, strong) NSString *lastComplaintId;
@property (nonatomic, assign, readonly) BOOL isNoMoreDate;

#pragma mark - 详情
@property (nonatomic, strong, readonly) RACCommand *cancelCommand;
@property (nonatomic, strong, readonly) RACCommand *confirmCommand;
@property (nonatomic, strong) NSString *complaintId;
@property (nonatomic, assign, readonly) BOOL isCancelSuccess;
@property (nonatomic, assign, readonly) BOOL isConfirmSuccess;

@end
