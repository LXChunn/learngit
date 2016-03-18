//
//  Car.m
//  消息转发Demo
//
//  Created by zhangyafeng on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "Car.h"
#import <objc/runtime.h>

@interface Car()

@end

@implementation Car

#pragma mark 消息转发方式2
-(id)forwardingTargetForSelector:(SEL)aSelector
{
    Car* car = [[Car alloc]init];
    if (aSelector == @selector(run)) {
        return car;
    }
    return nil;
}

-(void)run
{
    NSLog(@"car run");
}
@end
