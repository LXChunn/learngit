//
//  XPUnReadMessageViewModel.h
//  XPApp
//
//  Created by jy on 16/1/9.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"

@interface XPUnReadMessageViewModel : XPBaseViewModel
@property (nonatomic, strong, readonly) RACCommand *unReadCommand;
@property (nonatomic, strong, readonly) RACCommand *unReadSystemMessageCommand;
@property (nonatomic, assign, readonly) NSInteger unReadSystemMessageCounte;
@property (nonatomic, assign, readonly) NSInteger unReadMessageCounte;

@end
