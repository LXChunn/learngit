/**
 *  UIView+block.m
 *  ShareMerge
 *
 *  Created by huangxp on 10-8-25.
 *
 *  扩展UIView，GCD方式
 *
 *  Copyright (c) www.sharemerge.com All rights reserved.
 *
 */

#import "UIView+block.h"
#import <objc/runtime.h>

@interface UIView (private)

- (void)runBlockForKey:(void *)blockKey;
- (void)setBlock:(SGWhenTappedBlock)block forKey:(void *)blockKey;

- (UITapGestureRecognizer *)addTapGestureRecognizerWithTaps:(NSUInteger)taps touches:(NSUInteger)touches selector:(SEL)selector;
- (void)addRequirementToSingleTapsRecognizer:(UIGestureRecognizer *)recognizer;
- (void)addRequiredToDoubleTapsRecognizer:(UIGestureRecognizer *)recognizer;

@end

@implementation UIView (block)

static char kWhenTappedBlockKey;
static char kWhenDoubleTappedBlockKey;
static char kWhenTwoFingerTappedBlockKey;
static char kWhenTouchedDownBlockKey;
static char kWhenTouchedUpBlockKey;

- (void)runBlockForKey:(void *)blockKey
{
    SGWhenTappedBlock block = objc_getAssociatedObject(self, blockKey);
    if(block) {
        block();
    }
}

- (void)setBlock:(SGWhenTappedBlock)block forKey:(void *)blockKey
{
    self.userInteractionEnabled = YES;
    objc_setAssociatedObject(self, blockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)whenTapped:(SGWhenTappedBlock)block
{
    UITapGestureRecognizer *gesture = [self addTapGestureRecognizerWithTaps:1 touches:1 selector:@selector(viewWasTapped)];
    
    [self addRequiredToDoubleTapsRecognizer:gesture];
    [self setBlock:block forKey:&kWhenTappedBlockKey];
}

- (void)whenDoubleTapped:(SGWhenTappedBlock)block
{
    UITapGestureRecognizer *gesture = [self addTapGestureRecognizerWithTaps:2 touches:1 selector:@selector(viewWasDoubleTapped)];
    
    [self addRequirementToSingleTapsRecognizer:gesture];
    [self setBlock:block forKey:&kWhenDoubleTappedBlockKey];
}

- (void)whenTwoFingerTapped:(SGWhenTappedBlock)block
{
    [self addTapGestureRecognizerWithTaps:1 touches:2 selector:@selector(viewWasTwoFingerTapped)];
    [self setBlock:block forKey:&kWhenTwoFingerTappedBlockKey];
}

- (void)whenTouchedDown:(SGWhenTappedBlock)block
{
    [self setBlock:block forKey:&kWhenTouchedDownBlockKey];
}

- (void)whenTouchedUp:(SGWhenTappedBlock)block
{
    [self setBlock:block forKey:&kWhenTouchedUpBlockKey];
}

- (void)viewWasTapped
{
    [self runBlockForKey:&kWhenTappedBlockKey];
}

- (void)viewWasDoubleTapped
{
    [self runBlockForKey:&kWhenDoubleTappedBlockKey];
}

- (void)viewWasTwoFingerTapped
{
    [self runBlockForKey:&kWhenTwoFingerTappedBlockKey];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self runBlockForKey:&kWhenTouchedDownBlockKey];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self runBlockForKey:&kWhenTouchedUpBlockKey];
}

- (UITapGestureRecognizer *)addTapGestureRecognizerWithTaps:(NSUInteger)taps touches:(NSUInteger)touches selector:(SEL)selector
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = taps;
    tapGesture.numberOfTouchesRequired = touches;
    [self addGestureRecognizer:tapGesture];
    return tapGesture;
}

- (void)addRequirementToSingleTapsRecognizer:(UIGestureRecognizer *)recognizer
{
    for(UIGestureRecognizer *gesture in[self gestureRecognizers]) {
        if([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)gesture;
            if(tapGesture.numberOfTouchesRequired == 1 && tapGesture.numberOfTapsRequired == 1) {
                [tapGesture requireGestureRecognizerToFail:recognizer];
            }
        }
    }
}

- (void)addRequiredToDoubleTapsRecognizer:(UIGestureRecognizer *)recognizer
{
    for(UIGestureRecognizer *gesture in[self gestureRecognizers]) {
        if([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)gesture;
            if(tapGesture.numberOfTouchesRequired == 2 && tapGesture.numberOfTapsRequired == 1) {
                [recognizer requireGestureRecognizerToFail:tapGesture];
            }
        }
    }
}

@end