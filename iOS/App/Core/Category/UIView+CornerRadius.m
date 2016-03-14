//
//  UIView+CornerRadius.m
//  TestTextView
//
//  Created by jy on 16/2/26.
//  Copyright © 2016年 jy. All rights reserved.
//

#import "UIView+CornerRadius.h"

@implementation UIView (CornerRadius)

- (void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}

- (CGFloat)cornerRadius{
    return self.layer.cornerRadius;
}

@end
