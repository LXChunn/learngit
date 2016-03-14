//
//  XPUserInfoModel.h
//  XPApp
//
//  Created by CaoShunQing on 16/1/6.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"

@interface XPUserViewModel : XPBaseViewModel
@property (nonatomic, strong, readonly) RACCommand *updateCommand;
@property (nonatomic, strong) NSString *avataUrl;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, strong, readonly) NSString *successMessage;
@end
