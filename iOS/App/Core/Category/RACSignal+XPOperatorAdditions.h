//
//  RACSignal+XPOperatorAdditions.h
//  XPApp
//
//  Created by huangxinping on 15/11/13.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RACSignal (XPOperatorAdditions)

// Collects the elements of the receiver into an `NSSet`.
- (RACSignal *)rac_collectSetSignal;

@end
