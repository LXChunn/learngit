//
//  XPDeleteActivity.m
//  XPApp
//
//  Created by xinpinghuang on 12/24/15.
//  Copyright © 2015 ShareMerge. All rights reserved.
//

#import "XPDeleteActivity.h"

@implementation XPDeleteActivity

- (NSString *)activityType
{
    return @"Delete";
}

- (NSString *)activityTitle
{
    return @"删除";
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
