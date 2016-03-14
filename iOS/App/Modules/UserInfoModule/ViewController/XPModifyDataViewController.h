//
//  XPModifyDataViewController.h
//  XPApp
//
//  Created by CaoShunQing on 16/1/6.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewController.h"

@protocol selectdelegate <NSObject>

@optional
- (void)selectMessage:(NSString *)text;

@end

@interface XPModifyDataViewController : XPBaseViewController
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) id<selectdelegate>delegate;

@end
