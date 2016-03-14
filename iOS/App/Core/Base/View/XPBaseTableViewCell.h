//
//  XPBaseTableViewCell.h
//  Huaban
//
//  Created by huangxinping on 4/23/15.
//  Copyright (c) 2015 iiseeuu.com. All rights reserved.
//

#import "XPBaseReactiveView.h"
#import <ReactiveCocoa.h>
#import <UIKit/UIKit.h>
#import <XPKit/XPKit.h>

typedef void (^ClickAvatorBlock)();

@interface XPBaseTableViewCell : UITableViewCell <XPBaseReactiveView>

- (void)whenClickAvatorWithBlock:(ClickAvatorBlock)block;

@end
