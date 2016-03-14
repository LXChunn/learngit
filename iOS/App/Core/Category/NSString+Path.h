//
//  NSString+Path.h
//  App
//
//  Created by lingyj on 14-7-8.
//  Copyright (c) 2014年 ShareMerge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Path)

+ (NSString *)documentPath;
+ (void)      createPath;

+ (BOOL)checkIsTEXT:(NSString *)fileType;
+ (BOOL)checkIsRecordVoice:(NSString *)fileType;
+ (BOOL)checkIsPhoto:(NSString *)fileType;

+ (NSString *)hdPhotoPath;
+ (NSString *)photoPath;
+ (NSString *)recordVoicePath;
+ (NSString *)folderPathForStaticFileWithType:(NSString *)fileType;
+ (NSString *)chatFilePath;
@end
