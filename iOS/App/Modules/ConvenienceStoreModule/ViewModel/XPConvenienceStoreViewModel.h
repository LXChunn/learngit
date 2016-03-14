//
//  XPConvenienceStoreViewModel.h
//  XPApp
//
//  Created by iiseeuu on 16/1/15.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"
#import "XPConvenienceStoreModel.h"

@interface XPConvenienceStoreViewModel : XPBaseViewModel

@property (nonatomic, strong, readonly) NSArray *list;
@property (nonatomic, strong, readonly) RACCommand *reloadCommand;
@property (nonatomic, strong, readonly) RACCommand *moreCommand;
@property (nonatomic, assign, readonly) BOOL isNoMoreDate;

@end
