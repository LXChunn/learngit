//
//  XPMySecondCollecCell.h
//  XPApp
//
//  Created by CaoShunQing on 16/1/10.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPSecondHandItemsListModel.h"
#import <UIKit/UIKit.h>

@interface XPMySecondCollecCell : UITableViewCell

- (void)bindModel:(XPSecondHandItemsListModel *)model;

+ (NSInteger)heightForCell:(NSArray *)arry;

@end
