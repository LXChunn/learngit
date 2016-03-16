//
//  xcTableViewCell.h
//  分组的tableview
//
//  Created by Mac OS on 16/3/15.
//  Copyright © 2016年 JASON. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *lable;

@end
