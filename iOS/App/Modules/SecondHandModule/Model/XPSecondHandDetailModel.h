//
//  XPSecondHandDetailModel.h
//  XPApp
//
//  Created by jy on 15/12/30.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPAuthorModel.h"
#import "XPBaseModel.h"

@interface XPSecondHandDetailModel : XPBaseModel

@property (nonatomic, strong) XPAuthorModel *author;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSArray *picUrls;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *secondhandItemId;
@property (nonatomic, strong) NSString *status;             /**< 二手交易状态：1-未关闭；2-已关闭 */
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger commentsCount;
@end
