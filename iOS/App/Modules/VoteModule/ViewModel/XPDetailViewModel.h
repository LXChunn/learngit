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
@property (nonatomic,strong,readonly) RACCommand *collectionCommand;
@property (nonatomic,strong,readonly) RACCommand *deleteCommand;
@property (nonatomic,strong,readonly) RACCommand *closeCommand;
@property (nonatomic, strong, readonly) XPDetailModel *model;
@property (nonatomic, strong) NSString *forumtopicId;
@property (nonatomic,assign,readonly) BOOL isDeleteSuccess;
@property (nonatomic,assign,readonly) BOOL isCollectionSuccess;
@property (nonatomic,assign,readonly) BOOL isCloseSuccess;
@property (nonatomic,assign,readonly) BOOL isFavorit;

@end
