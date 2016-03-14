//
//  NSObject+XPDownloadFile.h
//  XPApp
//
//  Created by xinpinghuang on 1/5/16.
//  Copyright © 2016 ShareMerge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (XPDownloadFile)

- (void)downloadVideoFromURL:(NSString *)URL withProgress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(NSURL *filePath))completionBlock onError:(void (^)(NSError *error))errorBlock;

- (void)removeVideoAtPath:(NSURL *)filePath;

@end
