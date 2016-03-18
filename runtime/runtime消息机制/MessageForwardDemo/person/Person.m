//
//  Person.m
//  消息转发Demo
//
//  Created by zhangyafeng on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import "Car.h"

@implementation Person

#pragma mark 消息转发方式1
void run(id self,SEL _cmd) {
    NSLog(@"%@ %s", [self class], sel_getName(_cmd));
}
+(BOOL)resolveInstanceMethod:(SEL)sel
{
    if(sel == @selector(run)) {
        class_addMethod(self, sel, (IMP)run, "v@:");
        return YES;
    }
    
    return [super resolveInstanceMethod:sel];
}

+(BOOL)resolveClassMethod:(SEL)sel
{
    return [super resolveClassMethod:sel];
}






@end
