//
//  UIView+HESizeHeight.h
//  HelpEach
//
//  Created by jy on 15/8/25.
//  Copyright (c) 2015年 jy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HESizeHeight)

/**
 *  计算文本宽度
 *
 *  @param text     文本
 *  @param textFont 文字大小
 *  @param size     size
 *
 *  @return return value description
 */
+ (CGFloat)getTextSizeWidth:(NSString *)text font:(CGFloat)textFont withSize:(CGSize)size;

/**
 *  计算文本高度
 *
 *  @param text     <#text description#>
 *  @param textFont textFont description
 *  @param size     size description
 *
 *  @return return value description
 */
+ (CGFloat)getTextSizeHeight:(NSString *)text font:(CGFloat)textFont withSize:(CGSize)size;

@end
