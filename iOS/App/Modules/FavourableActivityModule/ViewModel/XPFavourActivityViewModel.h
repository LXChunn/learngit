//
//  XPFavourActivityViewModel.h
//  XPApp
//
//  Created by CaoShunQing on 16/1/18.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"

@interface XPFavourActivityViewModel : XPBaseViewModel
@property (nonatomic,strong,readonly)RACCommand *activityCommand;
@property (nonatomic,strong,readonly)RACCommand *activityMoreCommand;
@property (nonatomic,strong,readonly)NSString *sucessMessage;
@property (nonatomic,strong,readonly)NSArray *activityArray;
@property (nonatomic,assign,readonly)BOOL isNoMoreDate;

@end
