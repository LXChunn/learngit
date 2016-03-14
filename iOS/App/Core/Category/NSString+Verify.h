//
//  NSString+Verify.h
//  XPApp
//
//  Created by jy on 16/1/4.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Verify)

+ (BOOL)verifyPostSecondHandWithTitle:(NSString *)title price:(NSString *)price mobile:(NSString *)mobile content:(NSString *)content;

+ (BOOL)verifyVoteTitle:(NSString *)title content:(NSString *)content;

+ (BOOL)verifyPostVoteWithOptions:(NSArray *)options;

+ (BOOL)verifyForumicTopicWithTitle:(NSString *)title content:(NSString *)content;

+ (BOOL)verifyEventTitleWithTitle:(NSString *)title content:(NSString *)content;

+ (BOOL)verifyComment:(NSString *)comment;

+ (BOOL)verifyPrivateMessage:(NSString *)message;

+ (BOOL)verifyPostComplaintContent:(NSString *)content;

+ (BOOL)verifyPostMaintenanceContent:(NSString *)content;

+ (BOOL)verifyChangeUserPhoneWithMobile:(NSString *)mobile verifyCode:(NSString *)code;

+ (BOOL)verifyHousekeepingWith:(NSString *)title content:(NSString *)content mobile:(NSString *)mobile;

+ (BOOL)verifyStartPoint:(NSString *)startPoint;
+ (BOOL)verifyEndPoint:(NSString *)endPoint;
+ (BOOL)verifyMobilePhone:(NSString *)mobile;

+ (BOOL)verifyStartPoint:(NSString *)startPoint endPoint:(NSString *)endPoint mobilePhone:(NSString *)mobile startTime:(NSString *)startTime remark:(NSString *)remark;

@end
