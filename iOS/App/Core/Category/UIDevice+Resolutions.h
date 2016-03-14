//
//  UIDevice+Resolutions.h
//  HelpEach
//
//  Created by jy on 15/9/2.
//  Copyright (c) 2015年 jy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Resolutions)

+ (NSString *)currentResolution;

+ (NSString *) guideResolutionWithPage:(NSInteger)page;
@end
