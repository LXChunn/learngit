//
//  XPJFZDViewModel.h
//  XPApp
//
//  Created by Mac OS on 15/12/20.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseViewModel.h"
#import "XPPropertyBillModel.h"

@interface XPPropertyBillViewModel : XPBaseViewModel

@property (nonatomic, strong, readonly) NSArray *list;
@property (nonatomic, strong, readonly) RACCommand *listCommand;

@end
