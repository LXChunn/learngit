//
//  UIView+XPNib.m
//  XPApp
//
//  Created by huangxinping on 15/11/13.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "UIView+XPNib.h"

@implementation UIView (XPNib)

+ (instancetype)viewFromNib
{
    __weak id wSelf = self;
    
    // There is a swift bug, compiler will add a package name in front of the class name
    NSString *className = NSStringFromClass(self);
    NSArray *components = [className componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    className = [components lastObject];
    
    return [[[[UINib nibWithNibName:className bundle:[NSBundle bundleForClass:self]] instantiateWithOwner:nil options:nil] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject isKindOfClass:wSelf];
    }]] lastObject];
}

@end
