//
//  NSObject+XPShareSDK.h
//  XPApp
//
//  Created by xinpinghuang on 1/4/16.
//  Copyright © 2016 ShareMerge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

@interface NSObject (XPShareSDK)

- (void)shareWithTitle:(NSString *)title content:(NSString *)content images:(NSArray *)images url:(NSString *)url platformType:(SSDKPlatformType)platformType;

@end
