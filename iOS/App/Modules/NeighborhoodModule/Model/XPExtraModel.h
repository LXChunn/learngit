//
//  XPExtraModel.h
//  XPApp
//
//  Created by iiseeuu on 15/12/28.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"

@interface XPExtraModel : XPBaseModel

@property NSArray *picUrls;
@property NSString *participantsCount;
@property NSArray *participants;
@property NSString *startDate;
@property NSString *endDate;
@property BOOL open;
@property NSArray *options;
@property BOOL voted;
@property BOOL joined;

- (void)dictionaryWithOptions;

- (void)dictionaryWithParticipants;

@end
