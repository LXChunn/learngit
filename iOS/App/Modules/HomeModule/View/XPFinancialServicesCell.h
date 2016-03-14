//
//  XPFinancialServicesCell.h
//  XPApp
//
//  Created by jy on 16/1/14.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    FinancialServicesTypeOfcreditCard,                  /**< 信用卡 */
    FinancialServicesTypeOfloan,                        /**< 贷款 */
    FinancialServicesTypeOfCCBBuy,                      /**< 善融 */
} FinancialServicesType;

typedef void(^ClickFinancialServicesBlock)(FinancialServicesType type);
@interface XPFinancialServicesCell : UITableViewCell

+ (float)cellHeight;

- (void)whenClickFinaccialService:(ClickFinancialServicesBlock)block;

@end
