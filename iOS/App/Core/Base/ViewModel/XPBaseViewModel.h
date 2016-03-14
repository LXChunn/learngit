//
//  XPBaseViewModel.h
//  Huaban
//
//  Created by huangxinping on 4/21/15.
//  Copyright (c) 2015 iiseeuu.com. All rights reserved.
//

#import "XPAPIManager.h"
#import "XPBaseReactiveViewModel.h"
#import <ReactiveViewModel/ReactiveViewModel.h>
#import <UIKit/UIKit.h>

#define XPViewModelShortHand(viewModel) \
[viewModel.errors subscribeNext:^(id x) { \
@strongify(self);                          \
self.error = x;                            \
}];                                            \
[viewModel.executing subscribeNext:^(id x) { \
@strongify(self);                                     \
self.executing = x;                                   \
}];

@interface XPBaseViewModel : RVMViewModel<XPBaseReactiveViewModel>

/**
 *  API接口对象
 */
@property (nonatomic, strong) XPAPIManager *apiManager;

/**
 *  错误
 */
@property (nonatomic, strong) NSError *error;

/**
 *  是否正在执行
 */
@property (nonatomic, assign) NSNumber *executing;

@end
