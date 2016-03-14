//
//  XPHousekeepingListModel.h
//  XPApp
//
//  Created by jy on 16/2/23.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"
#import "XPAuthorModel.h"

@interface XPHousekeepingListModel : XPBaseModel
@property (nonatomic, strong) XPAuthorModel * author;
@property (nonatomic, strong) NSString * createdAt;
@property (nonatomic, strong) NSString * housekeepingItemId;
@property (nonatomic, strong) NSArray * picUrls;
@property (nonatomic, strong) NSString * title;

@end
