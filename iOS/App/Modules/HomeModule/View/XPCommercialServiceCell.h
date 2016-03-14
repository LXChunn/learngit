//
//  XPCommercialServiceCell.h
//  XPApp
//
//  Created by jy on 16/1/14.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CommercialServiceTypeOfCommunityBulletin,           /**< 社区公告 */
    CommercialServiceTypeOfPropertyWarranty,            /**< 物业保修 */
    CommercialServiceTypeOfPropertyPayment,             /**< 物业缴费 */
    CommercialServiceTypeOfCommunityForums,             /**< 社区论坛 */
} CommercialServiceType;

typedef void(^ClickCommercialServiceBlock)(CommercialServiceType type);

@interface XPCommercialServiceCell : UITableViewCell

+ (float)cellHeight;

- (void)whenClickCommercialService:(ClickCommercialServiceBlock)block;

@end
