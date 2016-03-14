//
//  UITableViewController+RACTableViewDataSource.m
//  XPApp
//
//  Created by huangxinping on 15/10/30.
//  Copyright © 2015年 iiseeuu.com. All rights reserved.
//

#import "RACTableViewDataSource.h"
#import "UITableViewController+RACTableViewDataSource.h"

@implementation UITableViewController (RACTableViewDataSource)

- (id<UITableViewDataSource>)rac_dataSource:(RACSignal *)signal reuseIdentifier:(NSString *)reuseIdentifier
{
    return [RACTableViewDataSource dataSource:signal tableView:(UITableView *)self.view andReuseIdentifier:reuseIdentifier];
}

@end

