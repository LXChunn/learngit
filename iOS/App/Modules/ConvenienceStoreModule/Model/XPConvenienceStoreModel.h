//
//  XPConvenienceStoreModel.h
//  XPApp
//
//  Created by iiseeuu on 16/1/15.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"


@interface XPConvenienceStoreModel : XPBaseModel

@property (nonatomic,strong) NSString * content;
@property (nonatomic,strong) NSString * createdAt;
@property (nonatomic,strong) NSString * cvsItemId;
@property (nonatomic,strong) NSArray * picUrls;
@property (nonatomic,strong) NSString * price;
@property (nonatomic,strong) NSString * telephone;
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * priceStr;
@end
