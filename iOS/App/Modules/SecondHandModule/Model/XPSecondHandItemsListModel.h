//
//  XPSecondHandItemsListModel.h
//  XPApp
//
//  Created by jy on 15/12/29.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"
#import "XPAuthorModel.h"

@interface XPSecondHandItemsListModel : XPBaseModel
@property  XPAuthorModel * author;
@property  NSString * createdAt;
@property  NSString * mobile;
@property  NSArray * picUrls;
@property  NSInteger price;
@property  NSString * secondhandItemId;
@property  NSString * status;
@property  NSString * title;
@property  NSString * type;

@end



