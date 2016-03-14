//
//  XPMyCommentViewModel.h
//  XPApp
//
//  Created by CaoShunQing on 16/1/8.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"

@interface XPMyCommentViewModel : XPBaseViewModel

@property (nonatomic, strong, readonly) RACCommand *mycommentsCommand;
@property (nonatomic, strong, readonly) RACCommand *moreCommentsCommand;
@property (nonatomic, strong, readonly) NSArray *myCommentArray;
@property (nonatomic, assign, readonly) BOOL isNoMoreDate;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSString *type;
@end
