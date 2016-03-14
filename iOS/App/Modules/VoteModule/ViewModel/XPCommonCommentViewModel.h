//
//  XPCommonCommentViewModel.h
//  XPApp
//
//  Created by jy on 16/1/8.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"

@interface XPCommonCommentViewModel : XPBaseViewModel
@property (nonatomic, strong, readonly) RACCommand *reloadCommentsCommand;
@property (nonatomic, strong, readonly) RACCommand *moreCommentsCommand;
@property (nonatomic, strong, readonly) RACCommand *replyCommand;
@property (nonatomic, strong) NSMutableArray *commentsList;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *replyOf;
@property (nonatomic, strong) NSString *forumtopicId;
@property (nonatomic, assign, readonly) BOOL isNoMoreDate;

@end
