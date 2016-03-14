//
//  NSString+XPAPIPath_Complaint.h
//  XPApp
//
//  Created by jy on 16/2/3.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XPAPIPath_Complaint)
+ (NSString *)api_complaint_path;

+ (NSString *)api_listcomplaint_path;//查询该用户所属房屋的物业投诉列表

+ (NSString *)api_cancelcomplaint_path;

+ (NSString *)api_confirmcomplaint_path;


@end
