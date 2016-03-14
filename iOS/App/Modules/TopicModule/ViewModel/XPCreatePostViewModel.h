//
//  XPCreatePostViewModel.h
//  XPApp
//
//  Created by iiseeuu on 15/12/30.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"
#import "XPTransferOrBuyModel.h"

@interface XPCreatePostViewModel : XPBaseViewModel
#pragma mark - 发布
@property (nonatomic, strong, readonly) RACCommand *createCommand;
@property (nonatomic, strong, readonly) RACCommand *updateCommand;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong, readonly) NSString *successMessage;
@property (nonatomic, strong) NSString *forumtopicId;
@property (nonatomic, strong) XPTransferOrBuyModel *model;
@property (nonatomic, strong, readonly) NSString *successMsg;

@end
