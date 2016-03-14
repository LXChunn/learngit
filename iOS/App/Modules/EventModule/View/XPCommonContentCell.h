//
//  XPCommonContentCell.h
//  XPApp
//
//  Created by jy on 16/1/4.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseTableViewCell.h"

typedef void (^TextViewEndEditingBlock)(NSString *text
                                        );
@interface XPCommonContentCell : XPBaseTableViewCell

- (void)configureUIWithContent:(NSString *)content placeholder:(NSString *)placeholder block:(TextViewEndEditingBlock)block;

@end
