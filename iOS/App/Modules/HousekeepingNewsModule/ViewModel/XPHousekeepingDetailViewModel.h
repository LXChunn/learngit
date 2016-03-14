//
//  XPHousekeepingDetailViewModel.h
//  XPApp
//
//  Created by jy on 16/2/23.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"
#import "XPHousekeepingDetailModel.h"

@interface XPHousekeepingDetailViewModel : XPBaseViewModel

@property (nonatomic, strong, readonly) RACCommand *detailCommand;
@property (nonatomic, strong, readonly) RACCommand *collectionCommand;
@property (nonatomic, strong, readonly) RACCommand *cancelCollectionCommand;
@property (nonatomic, strong, readonly) RACCommand *deleteCommand;
@property (nonatomic, strong) XPHousekeepingDetailModel *model;
@property (nonatomic, strong) NSString *housekeepingItemId;
@property (nonatomic, assign, readonly) BOOL isDeleteSuccess;
@property (nonatomic, assign, readonly) BOOL isFavorit;

@end
