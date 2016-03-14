//
//  XPCarpoolModelModel.h
//  XPApp
//
//  Created by iiseeuu on 16/2/22.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"
#import "XPAuthorModel.h"

@interface XPCarpoolModel : XPBaseModel


@property XPAuthorModel * author;
@property NSString * carpoolingItemId;
@property NSString * createdAt;
@property NSString * endPoint;
@property NSString * mobile;
@property NSString * remark;
@property NSString * startPoint;
@property NSString * time;
@property NSString * showTime;


@end
