//
//  XPMySecondHandCell.h
//  XPApp
//
//  Created by CaoShunQing on 16/1/10.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPMySecondHandCell : UITableViewCell

- (void)bindModel:(id)model;

+ (NSInteger)cellHeight:(NSArray *)arry;

@end
