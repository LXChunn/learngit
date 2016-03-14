//
//  XPHappyLifeViewModel.h
//  XPApp
//
//  Created by jy on 16/1/13.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"
#import "XPAPIManager+HappyLife.h"

@interface XPHappyLifeViewModel : XPBaseViewModel

@property (nonatomic,strong,readonly) RACCommand *webCommand;
@property (nonatomic,strong,readonly) NSString *webUrl;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *cityCode;
@property (nonatomic,assign) BillType billType;

@end
