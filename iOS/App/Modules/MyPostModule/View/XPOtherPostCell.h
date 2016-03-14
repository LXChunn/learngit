//
//  XPOtherPostCell.h
//  XPApp
//
//  Created by CaoShunQing on 16/2/22.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPOtherPostCell : UITableViewCell

- (void)bindModel:(id)model;

+ (NSInteger)cellHeight:(NSArray *)array;

@end
