//
//  XPCommonWebViewController.m
//  XPApp
//
//  Created by jy on 16/1/13.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPCommonWebViewController.h"
#import <XPWebView.h>

@interface XPCommonWebViewController ()<UIWebViewDelegate>
{
    NSURLRequest * _urlRequest;
}
@property (nonatomic,strong) PaymentSuccessBlock block;
@property (weak, nonatomic) IBOutlet XPWebView *myWebView;

@end

@implementation XPCommonWebViewController

#pragma mark - Life Circle
- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = self.navTitle;
    self.myWebView.remoteUrl = _webUrl;
    self.myWebView.webViewProxyDelegate = self;
}

#pragma mark - Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if ([request.URL.absoluteString isEqualToString:@"http://dragonbutler.memeyin.com/bank/pay_complete/"]) {
        //缴费支付成功的界面
        if (_block) {
            _block();
        }
        [self pop];
    }
    return YES;
}

#pragma mark - Event Responds

#pragma mark - Private Methods
- (void)whenPaymentSuccess:(PaymentSuccessBlock)block{
    _block = block;
}

#pragma mark - Getter & Setter

@end 
