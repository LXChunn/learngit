//
//  XPDetailModel.h
//  XPApp
//
//  Created by Mac OS on 16/1/4.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"
#import "XPAuthorModel.h"
#import "XPExtraModel.h"

@interface XPDetailModel: XPBaseModel

@property XPAuthorModel * author;
@property NSInteger commentsCount;
@property NSString *content;
@property NSString *createdAt;
@property XPExtraModel *extra;
@property NSString *forumTopicId;
@property BOOL isFavorite;
@property NSString *title;
@property NSString *type;
@property NSString *description;
@property NSString *accessToken;
@property NSString *userId;
@property NSString *nickname;
@property NSString *avatarUrl;
@property NSInteger participantsCount;
@property NSArray *participants;
@property BOOL open;

@end
