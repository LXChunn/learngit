//
//  XPSecondHandCommentsModel.h
//  XPApp
//
//  Created by jy on 16/1/5.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAuthorModel.h"
#import "XPBaseModel.h"

@interface XPSecondHandCommentsModel : XPBaseModel

@property (nonatomic, strong) XPAuthorModel *author;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSArray *replies;
@property (nonatomic, strong) NSString *secondhandCommentId;
@property (nonatomic, strong) NSString *forumCommentId;
@property (nonatomic, strong) NSString *housekeepingCommentId;

- (void)loadReplyDictionary;

@end
