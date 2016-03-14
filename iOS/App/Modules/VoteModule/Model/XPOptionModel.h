//
//  XPOptionModel.h
//  XPApp
//
//  Created by jy on 16/1/6.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"

@interface XPOptionModel : XPBaseModel

@property (nonatomic, strong) NSString *descriptionField;
@property (nonatomic, strong) NSString *voteOptionId;
@property (nonatomic, assign) NSInteger votesCount;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) NSInteger totalVoteCount;

@end
