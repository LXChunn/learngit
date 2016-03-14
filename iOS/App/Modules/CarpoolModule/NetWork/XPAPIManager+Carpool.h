//
//  XPAPIManager+Carpool.h
//  XPApp
//
//  Created by iiseeuu on 16/2/22.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager.h"

@interface XPAPIManager (Carpool)

//业主拼车列表
- (RACSignal *)carpoolListWithLastCarpoolingItemId:(NSString *)lastCarpoolingItemId;

//发布业主拼车
- (RACSignal *)carpoolingCreateWithStartPoint:(NSString *)startPoint withEndPoint:(NSString *)endPoint withTime:(NSString *)startTiem withRemark:(NSString *)remark withMobile:(NSString *)mobile;

//删除业主拼车
- (RACSignal *)deleteWithcarpoolCarpoolingItemId:(NSString *)carpoolingItemId;

@end
