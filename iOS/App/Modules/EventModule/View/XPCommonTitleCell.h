//
//  XPCommonTitleCell.h
//  XPApp
//
//  Created by jy on 16/1/4.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseTableViewCell.h"

typedef void (^TextFieldEndEditingBlock)(NSString *text
                                         );
@interface XPCommonTitleCell : XPBaseTableViewCell

- (void)configureUIWithTitle:(NSString *)title placeholder:(NSString *)placeholder block:(TextFieldEndEditingBlock)block;

@end
