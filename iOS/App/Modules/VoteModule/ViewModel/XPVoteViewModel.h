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
@property (nonatomic, strong, readonly) NSString *successMessage;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *options;

@end
