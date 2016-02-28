//
//  XPSecondHandCell.h
//  XPApp
//
//  Created by jy on 15/12/29.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseTableViewCell.h"
#import "XPBaseModel.h"

@interface XPSecondHandCell : XPBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

+ (NSInteger)cellHeightWithArray:(NSArray *)images;

- (void)bindModel:(XPBaseModel*)model;

@end