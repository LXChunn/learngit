//
//  XPDetailAnnounceViewController.h
//  XPApp
//
//  Created by iiseeuu on 15/12/21.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPAnnouncementModel.h"
#import "XPBaseViewController.h"

@interface XPDetailAnnounceViewController : XPBaseViewController

@property (nonatomic, strong) XPAnnouncementModel *detailModel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (nonatomic, assign) BOOL isHidden;

@end
