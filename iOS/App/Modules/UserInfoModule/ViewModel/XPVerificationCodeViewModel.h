//
//  XPverificationCodeViewModel.h
//  XPApp
//
//  Created by CaoShunQing on 16/1/15.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"

@interface XPVerificationCodeViewModel : XPBaseViewModel

@property (nonatomic,strong,readonly)RACCommand *verCodelCommand;
@property (nonatomic,strong)NSString *phone;
@property (nonatomic,assign,readonly)BOOL isRecciveSuccess;
@end
