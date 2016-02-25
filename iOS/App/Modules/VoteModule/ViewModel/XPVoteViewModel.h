//
//  XPVoteViewModel.h
//  XPApp
//
//  Created by Mac OS on 15/12/31.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"

@interface XPVoteViewModel : XPBaseViewModel
//发布
@property (nonatomic, strong, readonly) RACCommand *voteCommand;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) XPBaseViewModel *list;
@property (nonatomic, assign) BOOL createpostFinished;
@property (nonatomic,strong, readonly) NSString *successMsg;

@end
