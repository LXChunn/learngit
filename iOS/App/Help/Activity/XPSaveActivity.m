//
//  XPSaveActivity.m
//  XPApp
//
//  Created by xinpinghuang on 12/24/15.
//  Copyright © 2015 ShareMerge. All rights reserved.
//

#import "XPSaveActivity.h"

@implementation XPSaveActivity

- (NSString *)activityType
{
    return @"Save";
}

- (NSString *)activityTitle
{
    return @"保存到相册";
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"common_delete_button"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    if(activityItems.count) {
        return YES;
    }
    
    return NO;
}

- (UIViewController *)activityViewController
{
    return nil;
}

- (void)performActivity
{
    NSLog(@"%@", self.description);
}

@end
