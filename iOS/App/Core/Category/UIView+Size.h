//
//  UIView+Size.h
//  YJShare
//
//  Created by yangjw  on 13-2-25.
//  Copyright (c) 2013年 yangjw . All rights reserved.
//

/*
 UIButton *btnTest; // Or any other view
 
 btnTest.width   = 250;
 btnTest.height  = 100;
 
 btnTest.y      -= 100;
 btnTest.x      += 35;
 
 btnTest.centerX = 20;
 btnTest.centerY = 15;
 
 btnTest.size    = CGSizeMake(150, 70);
 btnTest.origin  = CGPointMake(25, 10);
 
 NSLog(@"%f", btnTest.lastSubviewOnX.x); // X value of the object with the largest X value
 NSLog(@"%f", btntest.lastSubviewOnY.y); // Y value of the object with the largest Y value
 
 [btnTest centerToParent]; // Centers button to its parent view, if exists
 */

#import <UIKit/UIKit.h>

@interface UIView (Size)

/** View's X Position */
@property (nonatomic, assign) CGFloat   x;

/** View's Y Position */
@property (nonatomic, assign) CGFloat   y;

/** View's width */
@property (nonatomic, assign) CGFloat   width;

/** View's height */
@property (nonatomic, assign) CGFloat   height;

/** View's origin - Sets X and Y Positions */
@property (nonatomic, assign) CGPoint   origin;

/** View's size - Sets Width and Height */
@property (nonatomic, assign) CGSize    size;

/** Y vale representing the bottom of the view **/
@property (nonatomic, assign) CGFloat   bottom;

/** X Value representing the right side of the view **/
@property (nonatomic, assign) CGFloat   right;

/** X value of the object's center **/
@property (nonatomic, assign) CGFloat   centerX;

/** Y value of the object's center **/
@property (nonatomic, assign) CGFloat   centerY;

/** Returns the Subview with the heighest X value **/
@property (nonatomic, strong, readonly) UIView *lastSubviewOnX;

/** Returns the Subview with the heighest Y value **/
@property (nonatomic, strong, readonly) UIView *lastSubviewOnY;

/**
 Centers the view to its parent view (if exists)
 */
-(void) centerToParent;

@end
