//
//  XPSecondHandViewController.h
//  XPApp
//
//  Created by jy on 15/12/28.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseViewController.h"

typedef enum : NSUInteger {
    MineTypeOfCollection,
    MineTypeOfSecondHand,
    MineTypeOfPost,
    MineTypeOfComment,
} MineType;

@interface XPSecondHandViewController : XPBaseViewController
@property (nonatomic, assign) MineType mineType;
@end
