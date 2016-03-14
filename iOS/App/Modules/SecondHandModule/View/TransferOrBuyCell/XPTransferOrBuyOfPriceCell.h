//
//  XPTransferOrBuyOfPriceCell.h
//  XPApp
//
//  Created by jy on 15/12/30.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseTableViewCell.h"
#import "XPTransferOrBuyModel.h"

typedef void (^TextFieldPriceInputBlock)(NSString *text
                                         );

@interface XPTransferOrBuyOfPriceCell : XPBaseTableViewCell

- (void)configureUIWithModel:(XPTransferOrBuyModel *)model block:(TextFieldPriceInputBlock)block;

@end
