//
//  XPTopicViewModel.h
//  XPApp
//
//  Created by iiseeuu on 15/12/29.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"
#import "XPTopicModel.h"

@interface XPTopicViewModel : XPBaseViewModel

@property (nonatomic, strong, readonly) NSArray *list;
@property (nonatomic, strong, readonly) RACCommand *reloadCommand;
@property (nonatomic, strong, readonly) RACCommand *moreCommand;
@property (nonatomic, assign, readonly) BOOL isNoMoreDate;

@end
