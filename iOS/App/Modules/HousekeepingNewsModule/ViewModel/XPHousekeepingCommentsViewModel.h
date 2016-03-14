//
//  XPHousekeepingCommentsViewModel.h
//  XPApp
//
//  Created by jy on 16/2/23.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"


@interface XPHousekeepingCommentsViewModel : XPBaseViewModel
@property (nonatomic, strong, readonly) RACCommand *reloadCommentsCommand;
@property (nonatomic, strong, readonly) RACCommand *moreCommentsCommand;
@property (nonatomic, strong, readonly) RACCommand *replyCommand;
@property (nonatomic, strong) NSMutableArray *commentsList;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *replyOf;
@property (nonatomic, strong) NSString *housekeepingItemId;
@property (nonatomic, assign, readonly) BOOL isNoMoreDate;

@end
