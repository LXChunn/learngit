//
//  XPComplaintViewModel.h
//  XPApp
//
//  Created by Mac OS on 15/12/24.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"

@interface XPComplaintViewModel : XPBaseViewModel

@property(nonatomic, strong, readonly)RACCommand *complaintCommand;
@property(nonatomic, strong)NSString *content;
@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)NSArray *picUrls;
@property(nonatomic, assign) BOOL submitFinished;
@property(nonatomic, strong, readonly) NSArray *list;
@property(nonatomic, strong, readonly)RACCommand *orderCommand;

@end
