//
//  UITableView+RACTableViewDataSource.m
//  XPApp
//
//  Created by huangxinping on 15/10/30.
//  Copyright © 2015年 iiseeuu.com. All rights reserved.
//

#import "UITableView+RACTableViewDataSource.h"

@implementation UITableView (RACTableViewDataSource)

- (id<UITableViewDataSource>)rac_dataSource:(RACSignal *)signal reuseIdentifier:(NSString *)reuseIdentifier
{
    return [RACTableViewDataSource dataSource:signal tableView:self andReuseIdentifier:reuseIdentifier];
}

@end
