//
//  XPMyPostViewModel.h
//  XPApp
//
//  Created by CaoShunQing on 16/1/8.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"

@interface XPMyPostViewModel : XPBaseViewModel

@property (nonatomic, strong, readonly) RACCommand *myforumtopicsCommand;
@property (nonatomic, strong, readonly) RACCommand *mysecondhandCommand;
@property (nonatomic, strong, readonly) RACCommand *moreForumtopicsCommand;
@property (nonatomic, strong, readonly) RACCommand *moreSecondHandCommand;
@property (nonatomic, strong, readonly) RACCommand *otherForumCommand;
@property (nonatomic, strong, readonly) RACCommand *moreOtherForumCommand;
@property (nonatomic, assign, readonly) BOOL isNoMoreDate;
@property (nonatomic, strong) NSString *lastid;
@property (nonatomic, assign) NSInteger pagesize;
@property (nonatomic, strong, readonly) NSArray *postArray;
@end
