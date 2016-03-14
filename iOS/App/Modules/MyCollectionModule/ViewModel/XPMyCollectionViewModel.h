//
//  XPMyCollectionViewModel.h
//  XPApp
//
//  Created by CaoShunQing on 16/1/8.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"

@interface XPMyCollectionViewModel : XPBaseViewModel

@property (nonatomic, strong, readonly) RACCommand *myfavoritesCommand;
@property (nonatomic, strong, readonly) RACCommand *morefavoritesCommand;
@property (nonatomic, strong, readonly) NSArray *myCollectArray;
@property (nonatomic, assign, readonly) BOOL isNoMoreDate;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSString *type;

@end
