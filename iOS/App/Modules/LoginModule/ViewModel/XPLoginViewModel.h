//
//  XPLoginViewModel.h
//  XPApp
//
//  Created by huangxinping on 15/9/23.
//  Copyright © 2015年 iiseeuu.com. All rights reserved.
//

#import "XPBaseViewModel.h"
#import "XPLoginModel.h"

@interface XPLoginViewModel : XPBaseViewModel

@property (nonatomic, assign) BOOL autoLogin;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *verificationCode;

@property (nonatomic, strong) RACSignal *phoneSignal;
@property (nonatomic, strong,readonly) RACCommand *userInfoCommand;
@property (nonatomic, strong, readonly) RACCommand *comfirmCommand;
@property (nonatomic, strong, readonly) RACCommand *vericationCodeCommand;

@property (nonatomic, strong, readonly) XPLoginModel *model;

@end
