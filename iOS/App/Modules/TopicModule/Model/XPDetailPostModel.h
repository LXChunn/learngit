//
//  XPDetailPostModelModel.h
//  XPApp
//
//  Created by iiseeuu on 15/12/30.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPAuthorModel.h"
#import "XPBaseModel.h"
#import "XPExtraModel.h"

@interface XPDetailPostModel : XPBaseModel

@property XPAuthorModel *author;
@property NSInteger commentsCount;
@property NSString *content;
@property NSString *createdAt;
@property XPExtraModel *extra;
@property NSString *forumTopicId;
@property BOOL isFavorite;
@property NSString *title;
@property NSString *type;

@end
