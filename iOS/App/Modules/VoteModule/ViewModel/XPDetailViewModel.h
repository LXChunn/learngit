//
//  XPDetailViewModel.h
//  XPApp
//
//  Created by Mac OS on 15/12/31.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"
#import "XPDetailModel.h"
#import <ReactiveCocoa.h>

@interface XPDetailViewModel : XPBaseViewModel

@property (nonatomic, strong, readonly) RACCommand *detailCommand;
@property (nonatomic, strong, readonly) RACCommand *collectionCommand;
@property (nonatomic, strong, readonly) RACCommand *cancelCollectionCommand;
@property (nonatomic, strong, readonly) RACCommand *deleteCommand;
@property (nonatomic, strong, readonly) RACCommand *closeCommand;
@property (nonatomic, strong, readonly) RACCommand *voteCommand;
@property (nonatomic, strong) XPDetailModel *model;
@property (nonatomic, strong) NSString *forumtopicId;
@property (nonatomic, strong) NSString *voteOptionId;
@property (nonatomic, assign, readonly) BOOL isDeleteSuccess;
@property (nonatomic, assign, readonly) BOOL isCloseSuccess;
@property (nonatomic, assign, readonly) BOOL isVoteSuccess;
@property (nonatomic, assign, readonly) BOOL isFavorit;
@property (nonatomic, assign) NSInteger type;                /**< 类型：1-论坛；2-二手*/
@end
