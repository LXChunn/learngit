//
//  NSObject+XPFlyweightTransmit.m
//  XPApp
//
//  Created by huangxinping on 15/7/16.
//  Copyright (c) 2015年 iiseeuu.com. All rights reserved.
//

#import "NSObject+XPFlyweightTransmit.h"
#import <objc/runtime.h>

@implementation NSObject (XPFlyweightTransmit)

- (id)xp_getAssociatedObjectForKey:(const char *)key
{
    const char *propName = key;
    id currValue = objc_getAssociatedObject(self, propName);
    return currValue;
}

- (id)xp_retainAssociatedObject:(id)obj forKey:(const char *)key;
{
    const char *propName = key;
    id oldValue = objc_getAssociatedObject(self, propName);
    objc_setAssociatedObject(self, propName, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return oldValue;
}

@end
