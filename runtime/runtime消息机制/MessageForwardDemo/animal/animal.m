//
//  animal.m
//  MessageForwardDemo
//
//  Created by Mac OS on 16/3/18.
//  Copyright © 2016年 think. All rights reserved.
//

#import "animal.h"

@implementation animal
#pragma mark 消息转发方式3
-(NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector
{
    NSString *sel = NSStringFromSelector(aSelector);
    //判断你要转发的SEL
    if([sel isEqualToString:@"run"]) {
        //为你的转发方法手动生成签名
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}
-(void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL selector = [anInvocation selector];
    //新建需要转发消息的对象
    animal* anim = animal.new;
    if ([anim respondsToSelector:selector]) {
        //唤醒这个方法
        [anInvocation invokeWithTarget:anim];
    }
}
- (void)run
{
    NSLog(@"%@ run",[self class]);
}
@end
