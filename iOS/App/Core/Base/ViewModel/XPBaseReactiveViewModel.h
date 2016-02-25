//
//  XPBaseReactiveViewModel.h
//  XPApp
//
//  Created by huangxinping on 15/11/16.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XPBaseModel;
@protocol XPBaseReactiveViewModel <NSObject>

- (void)bindModel:(XPBaseModel *)model;

@end
