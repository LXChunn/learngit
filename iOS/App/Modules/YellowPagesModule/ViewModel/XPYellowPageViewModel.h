//
//  XPYellowPageViewModel.h
//  XPApp
//
//  Created by CaoShunQing on 16/1/14.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"

@interface XPYellowPageViewModel : XPBaseViewModel
@property (nonatomic,strong,readonly)RACCommand *yellowPageCommand;
@property (nonatomic,strong,readonly)NSMutableArray *pageArray;
@end
