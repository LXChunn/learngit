//
//  XPSettingViewModel.h
//  XPApp
//
//  Created by CaoShunQing on 16/1/12.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"

@interface XPSettingViewModel : XPBaseViewModel
@property (nonatomic,strong,readonly) RACCommand *requestCommand;
@property (nonatomic,assign,readonly) BOOL isSuccess;
@property (nonatomic,strong,readonly) NSString *successMessage;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,assign) NSInteger version;
@end
