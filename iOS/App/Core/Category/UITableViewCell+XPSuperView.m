//
//  UITableViewCell+XPSuperView.m
//  XPApp
//
//  Created by huangxinping on 15/10/21.
//  Copyright © 2015年 iiseeuu.com. All rights reserved.
//

#import "UITableViewCell+XPSuperView.h"

@implementation UITableViewCell (XPSuperView)

- (UIView *)suitableSuperView
{
    UITableView *tableView;
    float Version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(Version >= 7.0) {
        tableView = (UITableView *)self.superview.superview;
    } else {
        tableView = (UITableView *)self.superview;
    }
    
    return tableView;
}

@end
