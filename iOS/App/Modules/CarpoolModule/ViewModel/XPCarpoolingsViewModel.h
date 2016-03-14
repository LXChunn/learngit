//
//  XPCarpoolingsViewModel.h
//  XPApp
//
//  Created by iiseeuu on 16/2/22.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"
#import "XPCarpoolModel.h"

@interface XPCarpoolingsViewModel : XPBaseViewModel

#pragma mark - 列表
@property (nonatomic, strong, readonly) NSArray *list;
@property (nonatomic, strong, readonly) RACCommand *listCommand;
@property (nonatomic, strong, readonly) RACCommand *listMoreCommand;
@property (nonatomic, assign, readonly) BOOL isNoMoreDate;
@property (nonatomic, strong) NSString *lastCarpoolingId;

#pragma mark - 发布
@property (nonatomic, strong, readonly) RACCommand *createCommand;
@property (nonatomic, strong) NSString *successMessage;
@property (nonatomic, strong) XPCarpoolModel *model;

#pragma mark - 删除
@property (nonatomic, strong, readonly) RACCommand *deleteCommand;
@property (nonatomic,strong)NSString *carpoolingItemId;
@property (nonatomic, assign, readonly) BOOL isDeleteSuccess;


@end
