//
//  XPUserInfoViewModel.h
//  XPApp
//
//  Created by jy on 15/12/31.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"
#import "XPLoginModel.h"

@interface XPUserInfoViewModel : XPBaseViewModel
@property (nonatomic, strong,readonly) RACCommand *userInfoCommand;
@property (nonatomic, strong, readonly) XPLoginModel *model;
@end
