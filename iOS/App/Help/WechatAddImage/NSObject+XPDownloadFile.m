//
//  NSObject+XPDownloadFile.m
//  XPApp
//
//  Created by xinpinghuang on 1/5/16.
//  Copyright © 2016 ShareMerge. All rights reserved.
//

#import "NSObject+XPDownloadFile.h"
#import <AFNetworking/AFNetworking.h>
#import <XPKit/XPKit.h>

@implementation NSObject (XPDownloadFile)

- (void)downloadVideoFromURL:(NSString *)URL withProgress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(NSURL *filePath))completionBlock onError:(void (^)(NSError *error))errorBlock
{
    //Configuring the session manager
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //Most URLs I come across are in string format so to convert them into an NSURL and then instantiate the actual request
    NSURL *formattedURL = [NSURL URLWithString:URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:formattedURL];
    
    //Watch the manager to see how much of the file it's downloaded
    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        //Convert totalBytesWritten and totalBytesExpectedToWrite into floats so that percentageCompleted doesn't get rounded to the nearest integer
        CGFloat written = totalBytesWritten;
        CGFloat total = totalBytesExpectedToWrite;
        CGFloat percentageCompleted = written/total;
        
        //Return the completed progress so we can display it somewhere else in app
        progressBlock(percentageCompleted);
    }];
    
    //Start the download
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //Getting the path of the document directory
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *fullURL = [documentsDirectoryURL URLByAppendingPathComponent:[URL MD5]];
        //If we already have a video file saved, remove it from the phone
        [self removeVideoAtPath:fullURL];
        return fullURL;
    }
                                                            completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                                if(!error) {
                                                                    //If there's no error, return the completion block
                                                                    completionBlock(filePath);
                                                                } else {
                                                                    //Otherwise return the error block
                                                                    errorBlock(error);
                                                                }
                                                            }];
    
    [downloadTask resume];
}

- (void)removeVideoAtPath:(NSURL *)filePath
{
    NSString *stringPath = filePath.path;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:stringPath]) {
        [fileManager removeItemAtPath:stringPath error:NULL];
    }
}

@end
