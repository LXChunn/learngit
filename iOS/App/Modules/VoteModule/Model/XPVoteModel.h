//
//  XPVoteModel.h
//  XPApp
//
//  Created by Mac OS on 15/12/30.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPAuthorModel.h"
#import "XPBaseModel.h"
#import "XPExtraModel.h"
@interface XPVoteModel : XPBaseModel

@property NSInteger commentsCount;
@property NSString *accessToken;
@property NSString *content;
@property NSString *createdAt;
@property XPAuthorModel *author;
@property NSString *forumTopicId;
@property NSString *title;
@property NSString *type;
@property NSString *userId;
@property NSString *nickname;
@property NSString *avatarUrl;
@property XPExtraModel *extra;
@property NSInteger participantsCount;
@property NSArray *participants;
@property BOOL open;

@end