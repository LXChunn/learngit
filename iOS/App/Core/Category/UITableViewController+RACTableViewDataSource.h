//
//  UITableViewController+RACTableViewDataSource.h
//  XPApp
//
//  Created by huangxinping on 15/10/30.
//  Copyright © 2015年 iiseeuu.com. All rights reserved.
//

#import "RACTableViewDataSource.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <UIKit/UIKit.h>

@interface UITableViewController (RACTableViewDataSource)

- (id<UITableViewDataSource>)rac_dataSource:(RACSignal *)signal reuseIdentifier:(NSString *)reuseIdentifier;

@end
