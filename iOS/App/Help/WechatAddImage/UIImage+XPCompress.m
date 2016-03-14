//
//  UIImage+XPCompress.m
//  XPApp
//
//  Created by xinpinghuang on 12/24/15.
//  Copyright © 2015 ShareMerge. All rights reserved.
//

#import "UIImage+XPCompress.h"

@implementation UIImage (XPCompress)

- (NSData *)xp_compress
{
    if(!self) {
        return nil;
    }
    
    NSData *imageData = nil;
    for(float compression = 1.0; compression >= 0.0; compression -= .1) {
        imageData = UIImageJPEGRepresentation(self, compression);
        NSInteger imageLength = imageData.length;
        if(imageLength/1024 <= 200) {
            break;
        }
    }
    return imageData;
}

@end
