//
//  XPComplaintModel.h
//  XPApp
//
//  Created by Mac OS on 15/12/28.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"

@interface XPComplaintModel : XPBaseModel

@property NSString *complaintId;
@property NSString *content;
@property NSString *status;
@property NSString *createdAt;
@property NSArray *picUrls;

@end
