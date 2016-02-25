//
//  XPTransferOrBuyViewModel.h
//  XPApp
//
//  Created by jy on 15/12/30.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"
#import <ReactiveCocoa.h>
#import "XPTransferOrBuyModel.h"
@interface XPTransferOrBuyViewModel : XPBaseViewModel

@property (nonatomic, strong, readonly) RACCommand *postCommand;
@property (nonatomic,strong) XPTransferOrBuyModel *model;
@property (nonatomic,strong, readonly) NSString *successMsg;

@end
