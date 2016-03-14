//
//  XPSecondHandReplyModel.h
//  XPApp
//
//  Created by jy on 16/1/5.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAuthorModel.h"
#import "XPBaseModel.h"
@interface XPSecondHandReplyModel : XPBaseModel

@property (nonatomic, strong) XPAuthorModel *author;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *secondhandCommentId;
@property (nonatomic, strong) NSString *replyOf;

@end
