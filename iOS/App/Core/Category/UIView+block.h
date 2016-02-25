/**
 *  UIView+block.h
 *  ShareMerge
 *
 *  Created by huangxp on 10-8-25.
 *
 *  扩展UIView，GCD方式
 *
 *  Copyright (c) www.sharemerge.com All rights reserved.
 *
 */
 
/** @file */    // Doxygen marker

#import <UIKit/UIKit.h>

typedef void (^SGWhenTappedBlock)();

@interface UIView (block) <UIGestureRecognizerDelegate>

/**
 *  @brief  单次点击事件block调度
 *
 *  @param  block 调度函数
 *
 */
- (void)whenTapped:(SGWhenTappedBlock)block;

/**
 *  @brief  双击事件block调度
 *
 *  @param  block 调度函数
 *
 */
- (void)whenDoubleTapped:(SGWhenTappedBlock)block;

/**
 *  @brief  双指事件block调度
 *
 *  @param  block 调度函数
 *
 */
- (void)whenTwoFingerTapped:(SGWhenTappedBlock)block;

/**
 *  @brief  按下事件block调度
 *
 *  @param  block 调度函数
 *
 */
- (void)whenTouchedDown:(SGWhenTappedBlock)block;

/**
 *  @brief  弹起事件block调度
 *
 *  @param  block 调度函数
 *
 */
- (void)whenTouchedUp:(SGWhenTappedBlock)block;

@end
