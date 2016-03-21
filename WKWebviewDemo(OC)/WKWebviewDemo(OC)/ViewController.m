//
//  ViewController.m
//  WKWebviewDemo(OC)
//
//  Created by Mac OS on 16/3/17.
//  Copyright © 2016年 JASON. All rights reserved.
//

#import "ViewController.h"
@import WebKit;

//@interface AAA : NSObject
//- (void)BBB;
//@end
//@implementation AAA
//- (void)BBB
//{
//    NSLog(@"good");
//}
//@end

@interface ViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //注册js
    WKWebViewConfiguration* config = [[WKWebViewConfiguration alloc]init];
    [config.userContentController addScriptMessageHandler:self name:@"LXC"];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    
    self.webView.allowsBackForwardNavigationGestures = YES;
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    //加载
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
    NSLog(@"页面开始加载");
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"当内容开始");
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"页面加载完成");
}

#pragma mark - WKScriptMessageHandler
//js调用app
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"%@",message.body);
    NSString* isClass;
    NSString* isFuntion;
    if ([message.name isEqual:@"LXC"]) {
        NSString* className = message.body[@"A"];
        NSString* functionName = message.body[@"B"];
        Class clSS = NSClassFromString(className);
        
        if ([clSS isKindOfClass:[NSObject class]]) {
            NSLog(@"类找到");
            isClass = @"类找到";
            id obj = [[clSS alloc]init];
            if ([clSS instancesRespondToSelector:NSSelectorFromString(functionName)]) {
                [obj performSelector:NSSelectorFromString(functionName)];
                NSLog(@"方法找到");
                isFuntion = @"方法找到";
            }else{
                NSLog(@"方法未找到");
                isFuntion = @"方法未找到";
            }
        }else{
            NSLog(@"类未找到");
            isClass = @"类未找到";
            NSLog(@"方法当然未找到");
            isFuntion = @"方法当然未找到";
            
        }
        
        //弹窗
        NSString* message = [NSString stringWithFormat:@"类名:%@\n方法名:%@\n%@\n%@",className,functionName,isClass,isFuntion];
        UIAlertController* alertCt = [UIAlertController alertControllerWithTitle:@"显示" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertCt animated:YES completion:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:^{
                //app调用js函数
                [self.webView evaluateJavaScript:@"alert('刘小椿')" completionHandler:nil];
            }];
        });
    }
}

#pragma mark - WKUIDelegate   js调用app
//alert捕获
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    //弹窗
    UIAlertController* alertCt = [UIAlertController alertControllerWithTitle:@"显示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alertCt addAction:action];
    
    [self presentViewController:alertCt animated:YES completion:nil];
    
}
//confirm捕获
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
    //弹窗
    UIAlertController* alertCt = [UIAlertController alertControllerWithTitle:@"显示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* trueAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(true);
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(false);
    }];
    [alertCt addAction:trueAction];
    [alertCt addAction:cancelAction];
    
    [self presentViewController:alertCt animated:YES completion:nil];
}

//prompt捕获
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    //弹窗
    UIAlertController* alertCt = [UIAlertController alertControllerWithTitle:@"显示" message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alertCt addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入内容";
    }];
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertCt.textFields[0].text);
    }];
    [alertCt addAction:action];
    
    [self presentViewController:alertCt animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - private

@end
