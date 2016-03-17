//
//  ViewController.m
//  WKWebviewDemo(OC)
//
//  Created by Mac OS on 16/3/17.
//  Copyright © 2016年 JASON. All rights reserved.
//

#import "ViewController.h"
@import WebKit;

@interface ViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebViewConfiguration* config = [[WKWebViewConfiguration alloc]init];
    [config.userContentController addScriptMessageHandler:self name:@"LXC"];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.webView.allowsBackForwardNavigationGestures = YES;
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com/"]]];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - WKNavigationDelegate
/*
 *错误回调
 */
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"error1 = %@",error);
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"error2 = %@",error);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"didStartProvisionalNavigation");
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"didCommitNavigation");
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"didFinishNavigation");
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"%@",message.body);
    if ([message.name isEqual:@"LXC"]) {
        NSDictionary* dict = message.body;
        NSString* className = dict[@"A"];
        NSString* functionNAme = dict[@"B"];
        NSString* classNM = [[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleName"] stringByAppendingFormat:@"%@",className];
        Class clSS = NSClassFromString(classNM);
        
        
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
