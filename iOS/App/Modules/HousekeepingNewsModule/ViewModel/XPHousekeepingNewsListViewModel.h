//
//  XPHousekeepingNewsListViewModel.h
//  XPApp
//
//  Created by jy on 16/2/22.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"


@interface XPHousekeepingNewsListViewModel : XPBaseViewModel

@property (nonatomic, strong, readonly) NSArray *list;
@property (nonatomic, strong, readonly) RACCommand *reloadCommand;
@property (nonatomic, strong, readonly) RACCommand *moreCommand;
@property (nonatomic, assign, readonly) BOOL isNoMoreDate;
@end
