//
//  NSDictionary+XPAPISignature.m
//  XPApp
//
//  Created by xinpinghuang on 12/15/15.
//  Copyright © 2015 ShareMerge. All rights reserved.
//

#import "NSDictionary+XPAPISignature.h"
#import <XPKit/XPKit.h>

@implementation NSDictionary (XPAPISignature)

- (NSString *)signature
{
    NSAssert(self.allKeys.count > 0, @"fillUserInfo - 参数签名时出错");
    
    // 签名算法的前提是所有的key是按字母排序过的
    NSArray *sortedKeys = [[self allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSArray *objects = [self objectsForKeys:sortedKeys notFoundMarker:[NSNull null]];
    NSAssert(sortedKeys.count == objects.count, @"signature - 大小不一致");
    NSMutableString *buffer = [NSMutableString string];
    for(NSInteger i = 0; i < sortedKeys.count; i++) {
        NSString *key = sortedKeys[i];
        NSString *value = objects[i];
        [buffer appendFormat:@"%@=%@&", key, value];
    }
    [buffer deleteCharactersInRange:NSMakeRange(buffer.length-1, 1)];
    return [buffer hmacAlgorithm:kCCHmacAlgSHA1 secret:@"pdcHYNAkItD41yIXj6FxMjss3yml3Q9C"];
}

@end
