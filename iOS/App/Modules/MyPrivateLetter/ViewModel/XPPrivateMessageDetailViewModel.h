//
//  XPPrivateMessageDetailViewModel.h
//  XPApp
//
//  Created by jy on 16/1/9.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"
#import "XPMessageDetailModel.h"

@interface XPPrivateMessageDetailViewModel : XPBaseViewModel
@property (nonatomic, strong, readonly) RACCommand *reloadCommand;
@property (nonatomic, strong, readonly) RACCommand *moreCommand;
@property (nonatomic, strong, readonly) RACCommand *sendMessageCommand;
@property (nonatomic, strong, readonly) NSMutableArray *list;
@property (nonatomic, assign, readonly) BOOL isSendSuccess;
@property (nonatomic, strong) NSString *contactUserId;
@property (nonatomic, strong) XPMessageDetailModel *detailModel;

@end
