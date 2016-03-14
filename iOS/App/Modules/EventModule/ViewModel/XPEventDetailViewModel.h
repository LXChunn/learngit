//
//  XPEventDetailViewModel.h
//  XPApp
//
//  Created by jy on 16/1/9.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"
#import "XPDetailModel.h"

@interface XPEventDetailViewModel : XPBaseViewModel

@property (nonatomic, strong, readonly) RACCommand *detailCommand;
@property (nonatomic, strong, readonly) RACCommand *joinEventCommand;
@property (nonatomic, strong, readonly) RACCommand *collectionCommand;
@property (nonatomic, strong, readonly) RACCommand *cancelCollectionCommand;
@property (nonatomic, strong, readonly) RACCommand *deleteCommand;
@property (nonatomic, strong, readonly) RACCommand *closeCommand;
@property (nonatomic, strong, readonly) XPDetailModel *model;
@property (nonatomic, strong) NSString *forumtopicId;
@property (nonatomic, assign, readonly) BOOL isDeleteSuccess;
@property (nonatomic, assign, readonly) BOOL isJoinSuccess;
@property (nonatomic, assign, readonly) BOOL isFavorit;

@end
