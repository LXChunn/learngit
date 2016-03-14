//
//  UIDevice+Resolutions.m
//  HelpEach
//
//  Created by jy on 15/9/2.
//  Copyright (c) 2015年 jy. All rights reserved.
//

#import "UIDevice+Resolutions.h"
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

@implementation UIDevice (Resolutions)

+ (NSString *) currentResolution
{
    CGFloat currentHeight = [UIScreen mainScreen].currentMode.size.height;

    if (currentHeight <= 960)
    {
        return @"Default_960.png";
    }
    else if (currentHeight < 1136)
    {
        return @"Default_960.png";
    }
    else if (currentHeight < 1334)
    {
        return @"Default_1136.png";
    }
    else if (currentHeight < 2001)
    {
        return @"Default_1334.png";
    }
    else if (currentHeight < 2208)
    {
        return @"Default_2001.png";
    }
    else
    {
        return @"Default_2208.png";
    }
}

+ (NSString *) guideResolutionWithPage:(NSInteger)page
{
    CGFloat currentHeight = [UIScreen mainScreen].currentMode.size.height;
    
    if (currentHeight <= 960)
    {
        return [NSString stringWithFormat:@"lead%ld_960.png",(long)page];
    }
    else if (currentHeight < 1136)
    {
        return [NSString stringWithFormat:@"lead%ld_960.png",(long)page];
    }
    else if (currentHeight < 1334)
    {
        return [NSString stringWithFormat:@"lead%ld_1136.png",(long)page];
    }
    else if (currentHeight < 2001)
    {
        return [NSString stringWithFormat:@"lead%ld_1334.png",(long)page];
    }
    else if (currentHeight < 2208)
    {
        return [NSString stringWithFormat:@"lead%ld_2001.png",(long)page];
    }
    else
    {
        return [NSString stringWithFormat:@"lead%ld_2208.png",(long)page];
    }
}

@end
