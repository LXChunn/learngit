//
//  XPSecondHandViewModel.h
//  XPApp
//
//  Created by jy on 15/12/29.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"

@interface XPSecondHandViewModel : XPBaseViewModel

@property (nonatomic, strong, readonly) NSArray *list;
@property (nonatomic, strong, readonly) RACCommand *secondHandReloadCommand;
@property (nonatomic, strong, readonly) RACCommand *secondHandMoreCommand;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign, readonly) BOOL isNoMoreDate;

@end
