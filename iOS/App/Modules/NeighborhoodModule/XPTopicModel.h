//
//  XPTopicModel.h
//  XPApp
//
//  Created by iiseeuu on 15/12/28.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"
#import "XPAuthorModel.h"
#import "XPExtraModel.h"

@interface XPTopicModel : XPBaseModel

@property XPAuthorModel * author;
@property NSString * commentsCount;
@property NSString * createdAt;
@property XPExtraModel * extra;
@property NSString * forumTopicId;
@property NSString * title;
@property NSString * type;


@property NSString * participantStr;

@end
