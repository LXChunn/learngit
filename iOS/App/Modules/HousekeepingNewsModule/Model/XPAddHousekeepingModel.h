//
//  XPAddHousekeepingModel.h
//  XPApp
//
//  Created by jy on 16/2/22.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"


@interface XPAddHousekeepingModel : XPBaseModel
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSArray *pictureUrls;

@end
