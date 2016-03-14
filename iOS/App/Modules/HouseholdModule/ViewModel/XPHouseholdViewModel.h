//
//  XPHouseholdViewModel.h
//  XPApp
//
//  Created by xinpinghuang on 12/15/15.
//  Copyright 2015 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"
#import "XPLoginModel.h"


@interface XPHouseholdViewModel : XPBaseViewModel

@property (nonatomic, strong) NSString *verificationCode;
@property (nonatomic, strong) RACCommand *bindCommand;
@property (nonatomic,strong,readonly) XPLoginModel *model;

@end
