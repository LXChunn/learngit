//
//  NSString+Path.m
//  App
//
//  Created by lingyj on 14-7-8.
//  Copyright (c) 2014年 ShareMerge. All rights reserved.
//

#import "NSString+Path.h"

#define kRecordVoice  @"RecordVoice"
#define kPhoto        @"Photo"
#define kHDPhoto      @"HDPhoto"
#define kChatFile     @"ChatFile"

@implementation NSString (Path)

+ (NSString *)documentPath
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return documentPath;
}

+ (void)createPath
{
    //语音
    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString recordVoicePath]])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:[NSString recordVoicePath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString photoPath]])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:[NSString photoPath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString hdPhotoPath]])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:[NSString hdPhotoPath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

#pragma mark - 文件夹路径
+ (NSString *)chatFilePath
{
    NSString *path = [[NSString documentPath] stringByAppendingPathComponent:kChatFile];
    return path;
}

+ (NSString *)hdPhotoPath
{
    NSString *path = [[NSString chatFilePath] stringByAppendingPathComponent:kHDPhoto];
    return path;
}

+ (NSString *)photoPath
{
    NSString *path = [[NSString chatFilePath] stringByAppendingPathComponent:kPhoto];
    return path;
}

+ (NSString *)recordVoicePath
{
    NSString *path = [[NSString chatFilePath] stringByAppendingPathComponent:kRecordVoice];
    return path;
}

+ (NSString *)folderPathForStaticFileWithType:(NSString *)fileType
{
    if ([NSString checkIsPhoto:fileType])
    {
        return [NSString photoPath];
    }
    else if ([NSString checkIsRecordVoice:fileType])
    {
        return [NSString recordVoicePath];
    }
    return nil;
}


#pragma mark - 文件一级

+ (BOOL)checkIsTEXT:(NSString *)fileType
{
    return [@[@"txt",@"message"] containsObject:[fileType lowercaseString]];
}

+ (BOOL)checkIsRecordVoice:(NSString *)fileType
{
    return [@[@"voice",@"audio"] containsObject:[fileType lowercaseString]];
}

+ (BOOL)checkIsPhoto:(NSString *)fileType
{
    return [@[@"jpeg",@"png",@"jpg",@"image"] containsObject:[fileType lowercaseString]];
}




@end
