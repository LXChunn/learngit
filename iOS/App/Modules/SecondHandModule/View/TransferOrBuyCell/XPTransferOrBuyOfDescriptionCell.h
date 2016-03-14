//
//  XPTransferOrBuyOfDescriptionCell.h
//  XPApp
//
//  Created by jy on 15/12/30.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseTableViewCell.h"
#import "XPTransferOrBuyModel.h"

typedef void (^TextViewInputBlock)(NSString *text
                                   );

@interface XPTransferOrBuyOfDescriptionCell : XPBaseTableViewCell

- (void)configureUIWithModel:(XPTransferOrBuyModel *)model block:(TextViewInputBlock)block;

@end
