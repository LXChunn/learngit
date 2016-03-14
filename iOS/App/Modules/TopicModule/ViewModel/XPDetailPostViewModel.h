//
//  XPDetailPostViewModel.h
//  XPApp
//
//  Created by iiseeuu on 15/12/30.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"
#import "XPDetailPostModel.h"
#import <ReactiveCocoa.h>

@interface XPDetailPostViewModel : XPBaseViewModel

@property (nonatomic, strong, readonly) RACCommand *detailCommand;
@property (nonatomic, strong, readonly) RACCommand *collectionCommand;
@property (nonatomic, strong, readonly) RACCommand *cancelCollectionCommand;
@property (nonatomic, strong, readonly) RACCommand *deleteCommand;
@property (nonatomic, strong, readonly) RACCommand *closeCommand;
@property (nonatomic, strong, readonly) XPDetailPostModel *model;
@property (nonatomic, strong) NSString *forumtopicId;
@property (nonatomic, assign, readonly) BOOL isDeleteSuccess;
@property (nonatomic, assign, readonly) BOOL isCloseSuccess;
@property (nonatomic, assign, readonly) BOOL isFavorit;
@end
