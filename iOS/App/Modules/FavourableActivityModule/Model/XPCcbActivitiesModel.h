//
//  XPCcbActivitiesModelModel.h
//  XPApp
//
//  Created by CaoShunQing on 16/1/18.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"


@interface XPCcbActivitiesModel : XPBaseModel
@property (nonatomic, strong) NSString * activityTarget;
@property (nonatomic, strong) NSString * ccbActivityId;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * endDate;
@property (nonatomic, strong) NSString * startDate;
@property (nonatomic, strong) NSString * themePicUrl;
@property (nonatomic, strong) NSString * title;

@end
