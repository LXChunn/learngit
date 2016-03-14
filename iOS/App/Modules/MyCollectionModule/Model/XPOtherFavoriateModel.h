//
//  XPOtherFavoriateModel.h
//  XPApp
//
//  Created by CaoShunQing on 16/2/23.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"
#import "XPAuthorModel.h"

@interface XPOtherFavoriateModel : XPBaseModel

@property (nonatomic, strong) XPAuthorModel * author;
@property (nonatomic, strong) NSString * createdAt;
@property (nonatomic, strong) NSString * favoriteItemId;
@property (nonatomic, strong) NSArray * picUrls;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * type;

@end
