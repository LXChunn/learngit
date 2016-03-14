//
//  XPCreditCardViewController.m
//  XPApp
//
//  Created by jy on 16/1/18.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPCreditCardViewController.h"
#import "XPCommonWebViewController.h"


@interface XPCreditCardViewController ()


@end

@implementation XPCreditCardViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Delegate

#pragma mark - Event Responds
- (IBAction)dragonApplyAction:(id)sender {
    XPCommonWebViewController * webViewController = (XPCommonWebViewController *)[self instantiateViewControllerWithStoryboardName:@"Forum" identifier:@"XPCommonWebViewController"];
    webViewController.webUrl = @"http://creditcard.ccb.com/ccbmobile/dragonapply.html";
    webViewController.navTitle = @"信用卡申请";
    [self pushViewController:webViewController];
}

- (IBAction)applyCheckAction:(id)sender {
    XPCommonWebViewController * webViewController = (XPCommonWebViewController *)[self instantiateViewControllerWithStoryboardName:@"Forum" identifier:@"XPCommonWebViewController"];
    webViewController.webUrl = @"http://m.ccb.com/cn/mobile/applycheck.html";
    webViewController.navTitle = @"办卡进度查询";
    [self pushViewController:webViewController];
}

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end 
