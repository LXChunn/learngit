//
//  XPAnnouncementViewModel.h
//  XPApp
//
//  Created by iiseeuu on 15/12/21.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPAnnouncementModel.h"
#import "XPBaseViewModel.h"

@interface XPAnnouncementViewModel : XPBaseViewModel

@property (nonatomic, strong, readonly) NSArray *list;
@property (nonatomic, strong, readonly) RACCommand *listCommand;
@property (nonatomic, strong) NSString *communityId;

@end
