//
//  XPEventViewModel.h
//  XPApp
//
//  Created by iiseeuu on 16/1/9.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"
#import "XPPostEventModel.h"

@interface XPEventViewModel : XPBaseViewModel

@property (nonatomic, strong, readonly) RACCommand *createCommand;
@property (nonatomic, strong, readonly) NSString *successMsg;
@property (nonatomic, strong) XPPostEventModel *model;
@property (nonatomic, strong) NSString *type;

@end
