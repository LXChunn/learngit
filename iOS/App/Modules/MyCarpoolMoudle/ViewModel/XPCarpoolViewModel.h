//
//  XPCarpoolViewModel.h
//  XPApp
//
//  Created by CaoShunQing on 16/2/23.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"

@interface XPCarpoolViewModel : XPBaseViewModel
@property (nonatomic ,strong, readonly)RACCommand *myCarpoolCommand;
@property (nonatomic ,strong, readonly)RACCommand *moreCarpoolCommand;
@property (nonatomic ,strong, readonly)NSString *lastItemId;
@property (nonatomic ,strong, readonly)NSArray *myCarpoolArray;
@property (nonatomic ,assign, readonly)BOOL isNoMoreData;
@end
