//
//  XPOtherForumModel.h
//  XPApp
//
//  Created by CaoShunQing on 16/2/22.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"

@interface XPOtherForumModel : XPBaseModel
@property (nonatomic, strong) NSString * createdAt;
@property (nonatomic, strong) NSString * otherItemId;
@property (nonatomic, strong) NSArray * picUrls;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * type;

@end
