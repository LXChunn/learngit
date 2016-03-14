//
//  XPMyCarpoolModel.h
//  XPApp
//
//  Created by CaoShunQing on 16/2/23.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"
#import "XPAuthorModel.h"

@interface XPMyCarpoolModel : XPBaseModel

@property (nonatomic, strong) XPAuthorModel * author;
@property (nonatomic, strong) NSString * carpoolingItemId;
@property (nonatomic, strong) NSString * createdAt;
@property (nonatomic, strong) NSString * endPoint;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * remark;
@property (nonatomic, strong) NSString * startPoint;
@property (nonatomic, strong) NSString * time;

@end
