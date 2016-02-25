//
//  XPTransferOrBuyViewController.h
//  XPApp
//
//  Created by jy on 15/12/29.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseViewController.h"
#import "XPTransferOrBuyModel.h"

typedef enum : NSUInteger {
    SecondHandGoodsTypeOfTransfer,
    SecondHandGoodsTypeOfBuy,
} SecondHandGoodsType;

@interface XPTransferOrBuyViewController : XPBaseViewController

@property (nonatomic,assign) SecondHandGoodsType secondHandGoodsType;
@property (nonatomic,strong) XPTransferOrBuyModel *transferOrBuyModel;

@end
