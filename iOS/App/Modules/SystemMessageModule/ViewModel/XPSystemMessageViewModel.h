//
//  XPSystemMessageViewModel.h
//  XPApp
//
//  Created by jy on 16/1/15.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"


@interface XPSystemMessageViewModel : XPBaseViewModel
@property (nonatomic, strong, readonly) RACCommand *reloadCommand;
@property (nonatomic, strong, readonly) RACCommand *moreCommand;
@property (nonatomic, strong, readonly) NSArray *list;
@property (nonatomic, assign, readonly) BOOL isNoMoreDate;


@end
