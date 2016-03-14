//
//  XPTransferOrBuyViewModel.h
//  XPApp
//
//  Created by jy on 15/12/30.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"
#import "XPTransferOrBuyModel.h"
#import <ReactiveCocoa.h>
@interface XPTransferOrBuyViewModel : XPBaseViewModel

@property (nonatomic, strong, readonly) RACCommand *postCommand;
@property (nonatomic, strong, readonly) RACCommand *updateCommand;
@property (nonatomic, strong) XPTransferOrBuyModel *model;
@property (nonatomic, strong) NSString *secodnHandItemId;
@property (nonatomic, strong, readonly) NSString *successMessage;

@end
