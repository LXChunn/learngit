//
//  XPMaintenanceViewModel.h
//  XPApp
//
//  Created by iiseeuu on 15/12/23.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"

@interface XPMaintenanceViewModel : XPBaseViewModel

#pragma mark - 发布
@property (nonatomic, strong, readonly) RACCommand *submitCommand;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSArray *picUrls;
@property (nonatomic, assign) BOOL submitFinished;

#pragma mark - 列表
@property (nonatomic, strong, readonly) NSArray *orders;
@property (nonatomic, strong, readonly) RACCommand *orderCommand;

@end
