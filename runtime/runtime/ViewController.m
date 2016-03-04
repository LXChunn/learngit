//
//  ViewController.m
//  runtime
//
//  Created by Mac OS on 16/3/4.
//  Copyright © 2016年 JASON. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(doSomething)];
    
    [self performSelector:@selector(secondVCMethod)];
    
    [ViewController runtimeSendValue:@"secondViewController" navi:self.navigationController];
    // Do any additional setup after loading the view, typically from a nib.
}
-(id)forwardingTargetForSelector:(SEL)aSelector
{
    Class class = NSClassFromString(@"secondViewController");
    UIViewController* vc = class.new;
    if (aSelector == NSSelectorFromString(@"secondVCMethod")) {
        NSLog(@"second do this !");
        
        return vc;
    }
    return nil;
}


+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == @selector(doSomething)) {
        NSLog(@"add method here");
        class_addMethod([self class], sel, (IMP)dynamicMethodIMP, "v@:");
        return YES;
    }
    
    return [super resolveInstanceMethod:sel];
}

void dynamicMethodIMP(id self,SEL _cmd){
    
    NSLog(@"doSomething SEl");
}


#pragma mark - 实现传值
+ (void)runtimeSendValue:(NSString*)vcName navi:(UINavigationController*)navi
{
    NSString* class = vcName;
    
    const char* className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(className);
    
    if (!newClass) {
        Class superClass = [NSObject class];
        //注册
        newClass = objc_allocateClassPair(superClass, className, 0);
        objc_registerClassPair(newClass);
    }
    //创建对象
    id instance = [[newClass alloc]init];
    
    //传值
    if ([self checkIsExistPropertyWithInstance:instance verifyPropertyName:@"LXC"]) {
        [instance setValue:@"刘小椿" forKey:@"LXC"];
    }else{
        NSLog(@"没有该属性");
    }
    
    [navi pushViewController:instance animated:YES];
}
/**
 *  检测对象是否存在该属性
 */
+ (BOOL)checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName
{
    unsigned int outCount, i;
    
    // 获取对象里的属性列表
    objc_property_t * properties = class_copyPropertyList([instance
                                                           class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property =properties[i];
        //  属性名转成字符串
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName isEqualToString:verifyPropertyName]) {
            free(properties);
            return YES;
        }
    }
    free(properties);
    
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
