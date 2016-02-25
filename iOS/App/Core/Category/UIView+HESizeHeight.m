//
//  UIView+HESizeHeight.m
//  HelpEach
//
//  Created by jy on 15/8/25.
//  Copyright (c) 2015年 jy. All rights reserved.
//

#import "UIView+HESizeHeight.h"

@implementation UIView (HESizeHeight)

+ (CGFloat)getTextSizeWidth:(NSString *)text font:(CGFloat)textFont withSize:(CGSize)size
{
    
    CGSize textSize = [text boundingRectWithSize:size // 用于计算文本绘制时占据的矩形块
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textFont]}        // 文字的属性
                                         context:nil].size;
    return textSize.width;
}

+ (CGFloat)getTextSizeHeight:(NSString *)text font:(CGFloat)textFont withSize:(CGSize)size
{
    
    CGSize textSize = [text boundingRectWithSize:size // 用于计算文本绘制时占据的矩形块
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                      attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:textFont]}        // 文字的属性
                                         context:nil].size;
    return textSize.height;
}

@end
