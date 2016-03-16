//
//  XCExpandView.h
//  分组的tableview
//
//  Created by Mac OS on 16/3/15.
//  Copyright © 2016年 JASON. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCExpandView : NSObject<UIScrollViewDelegate>

- (void)expandView:(UITableView*)tableview andImageView:(UIImageView*)imageview;

@end
