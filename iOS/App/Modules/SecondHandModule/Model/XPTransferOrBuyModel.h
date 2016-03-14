//
//  XPTransferOrBuyModel.h
//  XPApp
//
//  Created by jy on 15/12/30.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"

@interface XPTransferOrBuyModel : XPBaseModel

@property (nonatomic, strong) NSString *goodsTitle;
@property (nonatomic, strong) NSString *goodsDescriptions;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSMutableArray *pictures;
@property (nonatomic, strong) NSString *type;
@end
