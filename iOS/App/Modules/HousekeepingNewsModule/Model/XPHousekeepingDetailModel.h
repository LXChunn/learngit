//
//  XPHousekeepingDetailModel.h
//  XPApp
//
//  Created by jy on 16/2/23.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"
#import "XPAuthorModel.h"

@interface XPHousekeepingDetailModel : XPBaseModel

@property (nonatomic, strong) XPAuthorModel * author;
@property (nonatomic, assign) NSInteger commentsCount;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * createdAt;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSArray * picUrls;
@property (nonatomic, strong) NSString * shousekeepingItemId;
@property (nonatomic, strong) NSString * title;
@end
