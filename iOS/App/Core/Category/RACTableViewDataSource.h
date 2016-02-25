//
//  RACTableViewDataSource.h
//  XPApp
//
//  Created by huangxinping on 15/10/30.
//  Copyright © 2015年 iiseeuu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RACTableViewDataSource : NSObject <UITableViewDataSource> {
    UITableView *_tableView;
    NSString *_reuseIdentifier;
}

@property NSArray *data;

- (instancetype)initWithSource:(RACSignal *)source tableView:(UITableView *)tableView andReuseIdentifier:(NSString *)reuseIdentifier;

+ (instancetype)dataSource:(RACSignal *)signal tableView:(UITableView *)tableView andReuseIdentifier:(NSString *)reuseIdentifier;

@end
