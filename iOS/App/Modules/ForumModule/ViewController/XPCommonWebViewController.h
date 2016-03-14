//
//  XPCommonWebViewController.h
//  XPApp
//
//  Created by jy on 16/1/13.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewController.h"

typedef void(^PaymentSuccessBlock)();                   //缴费才会用到

@interface XPCommonWebViewController : XPBaseViewController

@property (nonatomic,strong) NSString *webUrl;
@property (nonatomic,strong) NSString *navTitle;

- (void)whenPaymentSuccess:(PaymentSuccessBlock)block;

@end
