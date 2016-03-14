//
//  XPChangeUserMobileViewModel.h
//  XPApp
//
//  Created by CaoShunQing on 16/1/15.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"
#import "XPLoginModel.h"

@interface XPChangeUserMobileViewModel : XPBaseViewModel

@property (nonatomic,strong,readonly)RACCommand *userNewPhoneCommand;
@property (nonatomic,strong,readonly)RACCommand *verFicationCodeCommand;
@property (nonatomic,assign,readonly) BOOL isChangeSuccess;
@property (nonatomic,assign,readonly) BOOL isReceiveCodeSuccess;
@property (nonatomic,strong) NSString *oldVerificationCode;
@property (nonatomic,strong) NSString *oldPhone;
@property (nonatomic,strong) NSString *nowVerificationCode;
@property (nonatomic,strong) NSString *nowPhone;
@property (nonatomic,strong,readonly) XPLoginModel *model;
@end
