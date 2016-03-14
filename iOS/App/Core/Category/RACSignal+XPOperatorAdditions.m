//
//  RACSignal+XPOperatorAdditions.h
//  XPApp
//
//  Created by huangxinping on 15/11/13.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "RACSignal+XPOperatorAdditions.h"

@implementation RACSignal (XPOperatorAdditions)

- (RACSignal *)rac_collectSetSignal
{
    return [[self
             aggregateWithStart:[NSSet set] reduce:^(NSSet *accumulated, id value) {
                 return [accumulated setByAddingObject:value ? : NSNull.null];
             }]
            setNameWithFormat:@"[%@] -rac_collectSet", self.name];
}

@end
