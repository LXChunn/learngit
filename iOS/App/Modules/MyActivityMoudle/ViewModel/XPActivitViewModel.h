//
//  XPActivitModel.h
//  XPApp
//
//  Created by CaoShunQing on 16/1/7.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"
#import "XPBaseViewModel.h"
#import "XPTopicModel.h"
#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
#import <ReactiveCocoa.h>

@interface XPActivitViewModel : XPBaseViewModel

@property (nonatomic, strong, readonly) NSArray *souceArray;
@property (nonatomic, strong, readonly) RACCommand *activtyCommand;

@end
