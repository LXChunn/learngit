//
//  XPHomeADCell.h
//  XPApp
//
//  Created by jy on 16/1/14.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickImageBlock)(NSInteger index);
@interface XPHomeADCell : UITableViewCell

+ (float)cellHeight;

- (void)configureUIWithImages:(NSArray *)images clickBlock:(ClickImageBlock)block;

@end
