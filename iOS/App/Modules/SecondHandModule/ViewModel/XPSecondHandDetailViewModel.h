//
//  XPSecondHandDetailViewModel.h
//  XPApp
//
//  Created by jy on 15/12/30.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"
#import "XPSecondHandCommentsModel.h"
#import "XPSecondHandDetailModel.h"
#import <ReactiveCocoa.h>

@interface XPSecondHandDetailViewModel : XPBaseViewModel
@property (nonatomic, strong, readonly) RACCommand *detailCommand;
@property (nonatomic, strong, readonly) RACCommand *reloadCommentsCommand;
@property (nonatomic, strong, readonly) RACCommand *moreCommentsCommand;
@property (nonatomic, strong, readonly) RACCommand *replyCommand;
@property (nonatomic, assign, readonly) BOOL isNoMoreDate;
@property (nonatomic, strong) NSMutableArray *commentsList;
@property (nonatomic, strong, readonly) RACCommand *collectionCommand;
@property (nonatomic, strong, readonly) RACCommand *cancelCollectionCommand;
@property (nonatomic, strong, readonly) RACCommand *deleteCommand;
@property (nonatomic, strong, readonly) RACCommand *closeCommand;
@property (nonatomic, strong, readonly) XPSecondHandDetailModel *detailModel;
@property (nonatomic, assign, readonly) BOOL isCloseSuccess;
@property (nonatomic, assign, readonly) BOOL isDeleteSuccess;
@property (nonatomic, assign, readonly) BOOL isFavorite;
@property (nonatomic, strong) NSString *secondHandItemId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *replyOf;
@property (nonatomic, assign) NSInteger type;                /**< 类型：1-论坛；2-二手*/

@end
