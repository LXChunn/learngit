//
//  XPPostEventModel.h
//  XPApp
//
//  Created by jy on 16/1/4.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"

@interface XPPostEventModel : XPBaseModel
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *beginDate;
@property (nonatomic, strong) NSString *showBeginDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *showEndDate;

@property (nonatomic, strong) NSMutableArray *picUrls;

@end
