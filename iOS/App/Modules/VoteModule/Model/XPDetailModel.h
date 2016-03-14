//
//  XPDetailModel.h
//  XPApp
//
//  Created by Mac OS on 16/1/4.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAuthorModel.h"
#import "XPBaseModel.h"
#import "XPExtraModel.h"

@interface XPDetailModel : XPBaseModel

@property (nonatomic, strong) XPAuthorModel *author;
@property (nonatomic, assign) NSInteger commentsCount;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) XPExtraModel *extra;
@property (nonatomic, strong) NSString *forumTopicId;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;

@end
