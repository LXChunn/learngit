//
//  XPSecondHandDetailViewModel.h
//  XPApp
//
//  Created by jy on 15/12/30.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"
#import <ReactiveCocoa.h>
#import "XPSecondHandDetailModel.h"

@interface XPSecondHandDetailViewModel : XPBaseViewModel
@property (nonatomic,strong,readonly) RACCommand *detailCommand;
@property (nonatomic,strong,readonly) RACCommand *collectionCommand;
@property (nonatomic,strong,readonly) RACCommand *deleteCommand;
@property (nonatomic,strong,readonly) RACCommand *closeCommand;
@property (nonatomic,strong,readonly) XPSecondHandDetailModel *detailModel;
@property (nonatomic,assign,readonly) BOOL isCollectionSuccess;
@property (nonatomic,assign,readonly) BOOL isCloseSuccess;
@property (nonatomic,assign,readonly) BOOL isDeleteSuccess;
@property (nonatomic,assign,readonly) BOOL isFavorite;
@property (nonatomic,strong) NSString *secondHandItemId;
@property (nonatomic,assign) NSInteger type;                /**< 类型：1-论坛；2-二手*/


@end
