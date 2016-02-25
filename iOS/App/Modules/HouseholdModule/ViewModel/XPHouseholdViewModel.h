//
//  XPHouseholdViewModel.h
//  XPApp
//
//  Created by xinpinghuang on 12/15/15.
//  Copyright 2015 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"


@interface XPHouseholdViewModel : XPBaseViewModel

@property (nonatomic,strong)NSString *verificationCode;
@property (nonatomic,strong)RACCommand *bindCommand;


@end
