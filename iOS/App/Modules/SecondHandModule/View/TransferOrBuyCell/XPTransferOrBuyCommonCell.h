//
//  XPTransferOrBuyCommonCell.h
//  XPApp
//
//  Created by jy on 15/12/30.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseTableViewCell.h"
#import "XPTransferOrBuyModel.h"

typedef enum : NSUInteger {
    TransferOrBuyCommonTypeOfTitle,
    TransferOrBuyCommonTypeOfPhone,
} TransferOrBuyCommonType;

typedef void(^TextFieldCommonInputBlock)(NSString *text);

@interface XPTransferOrBuyCommonCell : XPBaseTableViewCell

- (void)configureUIWithModel:(XPTransferOrBuyModel *)model type:(TransferOrBuyCommonType)type block:(TextFieldCommonInputBlock)block;


@end
