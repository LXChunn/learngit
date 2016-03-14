//
//  XPMyCommentListModel.h
//  XPApp
//
//  Created by jy on 16/1/9.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAuthorModel.h"
#import "XPBaseModel.h"

@interface XPMyCommentListModel : XPBaseModel

@property (nonatomic, strong) NSString *commentId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) XPAuthorModel *otherSide;
@property (nonatomic, strong) NSString *topicId;
@property (nonatomic, strong) NSString *topicTitle;
@property (nonatomic, strong) NSString *topicType;

@end
