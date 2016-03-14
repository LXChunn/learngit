//
//  NSString+Verify.m
//  XPApp
//
//  Created by jy on 16/1/4.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "NSString+Category.h"
#import "NSString+Verify.h"
#import "XPLoginModel.h"
#import <XPToast.h>
@implementation NSString (Verify)

+ (BOOL)verifyPostSecondHandWithTitle:(NSString *)title price:(NSString *)price mobile:(NSString *)mobile content:(NSString *)content
{
    if ([price isEqualToString:@"-1"]){
        price = nil;
    }
    if(price.length > 0) {
        if(![price valiteNumberAndPoint]) {
            [XPToast showWithText:@"价格输入不正确"];
            return NO;
        } else {
            if([price floatValue] < 0) {
                [XPToast showWithText:@"价格不得小于0"];
                return NO;
            }
        }
    }
    else if([title isBlank]||!title) {
        [XPToast showWithText:@"请输入宝贝标题"];
        return NO;
    } else if(title.length > 20) {
        [XPToast showWithText:@"宝贝标题最长20个字"];
        return NO;
    }else if(content.length > 200) {
        [XPToast showWithText:@"宝贝内容最长200字"];
        return NO;
    }else if(mobile.length > 0) {
        if(![mobile validateMobile]) {
            [XPToast showWithText:@"请输入正确的手机号"];
            return NO;
        }
    }
    return YES;
}

+ (BOOL)verifyVoteTitle:(NSString *)title content:(NSString *)content
{
    if([title isBlank]||!title) {
        [XPToast showWithText:@"请填写投票标题"];
        return NO;
    } else if(title.length > 20) {
        [XPToast showWithText:@"投票标题最长20个字"];
        return NO;
    } else if([content isBlank]||!content) {
        [XPToast showWithText:@"请填写投票描述"];
        return NO;
    } else if(content.length > 200) {
        [XPToast showWithText:@"投票内容最长200个字"];
        return NO;
    }else if(content.length<10){
        [XPToast showWithText:@"投票描述至少10个字"];
        return NO;
    }
    return YES;
}

+ (BOOL)verifyPostVoteWithOptions:(NSArray *)options
{
    for(NSString *option in options) {
        if([option isBlank]||!option) {
            [XPToast showWithText:@"请输入选项内容"];
            return NO;
        } else if(option.length > 50) {
            [XPToast showWithText:@"选项内容最长50个字"];
            return NO;
        }
    }
    return YES;
}

+ (BOOL)verifyForumicTopicWithTitle:(NSString *)title content:(NSString *)content
{
    if([title isBlank]||!title) {
        [XPToast showWithText:@"请输入帖子标题"];
        return NO;
    } else if(title.length > 20) {
        [XPToast showWithText:@"帖子标题最长20个字"];
        return NO;
    } else if([content isBlank]||!content) {
        [XPToast showWithText:@"请输入帖子内容"];
        return NO;
    } else if(content.length < 10) {
        [XPToast showWithText:@"帖子内容至少十个字"];
        return NO;
    } else if(content.length > 2000) {
        [XPToast showWithText:@"帖子内容最长2000个字"];
        return NO;
    }
    
    return YES;
}

+ (BOOL)verifyEventTitleWithTitle:(NSString *)title content:(NSString *)content
{
    if([title isBlank]||!title) {
        [XPToast showWithText:@"请输入活动标题"];
        return NO;
    } else if(title.length > 20) {
        [XPToast showWithText:@"活动标题最长20个字"];
        return NO;
    } else if([content isBlank]||!content) {
        [XPToast showWithText:@"请输入活动内容"];
        return NO;
    } else if(content.length < 10) {
        [XPToast showWithText:@"活动内容至少十个字"];
        return NO;
    } else if(content.length > 2000) {
        [XPToast showWithText:@"活动内容最长2000个字"];
        return NO;
    }
    
    return YES;
}

+ (BOOL)verifyComment:(NSString *)comment
{
    if(comment.length > 200) {
        [XPToast showWithText:@"评论最长200个字"];
        return NO;
    }
    
    return YES;
}

+ (BOOL)verifyPrivateMessage:(NSString *)message
{
    if(message.length > 200) {
        [XPToast showWithText:@"私信最长2000个字"];
        return NO;
    }
    
    return YES;
}

+ (BOOL)verifyPostComplaintContent:(NSString *)content
{
    if(content.length < 10) {
        [XPToast showWithText:@"投诉内容至少10个字"];
        return NO;
    } else if(content.length > 500) {
        [XPToast showWithText:@"投诉内容最长500字"];
        return NO;
    }
    
    return YES;
}

+ (BOOL)verifyPostMaintenanceContent:(NSString *)content
{
    if(content.length < 10) {
        [XPToast showWithText:@"报修内容至少10个字"];
        return NO;
    } else if(content.length > 500) {
        [XPToast showWithText:@"报修内容最长200字"];
        return NO;
    }
    
    return YES;
}

+ (BOOL)verifyStartPoint:(NSString *)startPoint
{
    if (startPoint.length<1) {
        [XPToast showWithText:@"请输入起点信息"];
        return NO;
    }else if (startPoint.length>20)
    {
        [XPToast showWithText:@"起点信息最长20字"];
        return NO;
    }
    return YES;
}

+ (BOOL)verifyEndPoint:(NSString *)endPoint
{
    if (endPoint.length<1) {
        [XPToast showWithText:@"请输入终点信息"];
        return NO;
    }else if (endPoint.length>20)
    {
        [XPToast showWithText:@"终点信息最长20字"];
        return NO;
    }
    return YES;
    
}

+ (BOOL)verifyMobilePhone:(NSString *)mobile
{
    if (mobile.length>0) {
        if(![mobile validateMobile]) {
            [XPToast showWithText:@"请输入正确的手机号"];
            return NO;
        }
        
    }
    return YES;
}


+ (BOOL)verifyStartPoint:(NSString *)startPoint endPoint:(NSString *)endPoint mobilePhone:(NSString *)mobile startTime:(NSString *)startTime remark:(NSString *)remark
{
//    if ([startPoint isBlank]||!startPoint) {
//        [XPToast showWithText:@"请输入起点信息"];
//        return NO;
//    }else if (startPoint.length>20){
//        [XPToast showWithText:@"起点信息最长20字"];
//        return NO;
//    }else if ([endPoint isBlank]||!endPoint){
//        [XPToast showWithText:@"请输入终点信息"];
//        return NO;
//    }else if (endPoint.length>20){
//        [XPToast showWithText:@"终点信息最长20字"];
//        return NO;
//    }else if (startTime.length<1){
//        [XPToast showWithText:@"请选择出发时间"];
//    }else if (mobile.length>0) {
//        if(![mobile validateMobile]) {
//            [XPToast showWithText:@"请输入正确的手机号"];
//            return NO;
//        }
//    }
    
    if ([startPoint isBlank]||!startPoint) {
        [XPToast showWithText:@"请输入起点信息"];
        return NO;
    }
    if (startPoint.length>20){
        [XPToast showWithText:@"起点信息最长20字"];
        return NO;
    }
    if ([endPoint isBlank]||!endPoint){
        [XPToast showWithText:@"请输入终点信息"];
        return NO;
    }
    if (endPoint.length>20){
        [XPToast showWithText:@"终点信息最长20字"];
        return NO;
    }
    if (startTime.length<1){
        [XPToast showWithText:@"请选择出发时间"];
    }
    if (mobile.length>0) {
        if(![mobile validateMobile]) {
            [XPToast showWithText:@"请输入正确的手机号"];
            return NO;
        }
    }else {
        [XPToast showWithText:@"请输入您的手机号"];
        return NO;

    }
    
    if (remark.length>200) {
        [XPToast showWithText:@"备注信息最多200字"];
        return NO;
    }
    
    
    return YES;
}



+ (BOOL)verifyChangeUserPhoneWithMobile:(NSString *)mobile verifyCode:(NSString *)code
{
    if ([mobile isEqualToString:[XPLoginModel singleton].mobile]) {
        [XPToast showWithText:@"新手机号和旧手机号不能相同"];
        return NO;
    }
    if (mobile.length!=11) {
        [XPToast showWithText:@"请输入11位手机号"];
        return NO;
    }
    if (code!=nil) {
        if (code.length!=6) {
            [XPToast showWithText:@"验证码须6位"];
            return NO;
        }
    }
    return YES;
}

+ (BOOL)verifyHousekeepingWith:(NSString *)title content:(NSString *)content mobile:(NSString *)mobile{
    if (title.length < 1) {
        [XPToast showWithText:@"请输入标题"];
        return NO;
    }
    if (content.length < 1) {
        [XPToast showWithText:@"请输入详细信息"];
        return NO;
    }
    if (content.length < 10) {
        [XPToast showWithText:@"详细信息不得低于10个字"];
        return NO;
    }
    if (mobile.length > 0) {
        if(![mobile validateMobile]) {
            [XPToast showWithText:@"请输入正确的手机号"];
            return NO;
        }
    }
    return YES;
}

@end
