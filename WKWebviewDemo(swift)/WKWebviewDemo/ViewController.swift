//
//  ViewController.swift
//  WKWebviewDemo
//
//  Created by Mac OS on 16/3/17.
//  Copyright © 2016年 JASON. All rights reserved.
//

import UIKit
import WebKit
import Foundation
class ViewController: UIViewController, WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler{
    @IBOutlet weak var gobackBtn: UIButton!
    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var progress: UIProgressView!

    var wk :WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let conf = WKWebViewConfiguration()
        //注册js
        conf.userContentController.addScriptMessageHandler(self, name: "LXC")
        self.wk = WKWebView(frame: CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 100),configuration: conf)
        
        
        self.wk?.navigationDelegate = self
        self.wk?.UIDelegate = self
        
        self.wk.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.baidu.com/")!))
        self.view.addSubview(self.wk)
        
        
        
        //允许手势，后退前进等操作
        self.wk.allowsBackForwardNavigationGestures = true
        
        //监听是否可以前进后退，修改btn.enable属性
        self.wk.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        //监听加载进度
        self.wk.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
    }
    
    //WKScriptMessageHandler
    //js调用app
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage)
    {
        print(message.name)
        print(message.body.description)
        
        var function = "" , clasS  = ""
        if message.name == "LXC"{
            if let dict = message.body as? NSDictionary,
            className = dict["A"]?.description,
                functionName = dict["B"]?.description{
                    if let clss = NSClassFromString(NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName")!.description + "." + className)as? NSObject.Type{
                        clasS = "类找到"
                        let obj = clss.init()
                        
                        if obj.respondsToSelector(NSSelectorFromString(functionName)){
                            obj.performSelector(NSSelectorFromString(functionName))
                            function = "方法找到"
                        }else{
                            function = "方法未找到"
                        }
                    }else{
                        clasS = "类未找到"
                        function = "方法当然也未找到"
                    }
            }
            print("\(clasS)")
            print("\(function)")
            
            
            if let dic = message.body as? NSDictionary{
                let alert = UIAlertController(title: "显示", message: "类名:\(dic["A"]?.description)\n方法名:\(dic["B"]?.description)\n\(clasS)\n\(function)", preferredStyle: .Alert)
                
                self.presentViewController(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "显示", message: message.body.description, preferredStyle: .Alert)
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
        //定时
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("someSeletor"), userInfo: nil, repeats: false)
        
    }
    
    //navigationdelegate
//    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void)
//    {
//        
//    }
//    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void)
//    {
//        
//    }

    func webView(webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!)
    {
        print("接收到服务器跳转请求之后调用")
        
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        self.progress.progress = 0.0
        print("启动了。。。")
    }
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!)
    {
        print("内容开始返回")
    }
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!)
    {
        print("页面加载完成")
    }
    /*
     * 错误回调
     */
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError)
    {
        NSLog("错误1:\(error.debugDescription)")
    }
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError)
    {
        NSLog("错误2:\(error.debugDescription)")
    }
    
    //UIdelegate
    func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: { (_) -> Void in
            completionHandler()
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
//
    func webView(webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: (Bool) -> Void) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: { (_) -> Void in
            // 点击完成后，可以做相应处理，最后再回调js端
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: { (_) -> Void in
            // 点击取消后，可以做相应处理，最后再回调js端
            completionHandler(false)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func webView(webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: (String?) -> Void) {
        let alert = UIAlertController(title: prompt, message: defaultText, preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
            textField.placeholder = "请输入内容"
        }
        alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: { (_) -> Void in
            // 处理好之前，将值传到js端
            completionHandler(alert.textFields![0].text!)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    //重写kvo方法
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "loading") {
            self.gobackBtn.enabled = self.wk.canGoBack
            self.forwardBtn.enabled = self.wk.canGoForward
        }
        if (keyPath == "estimatedProgress") {
            
//            self.progress.hidden = self.wk.estimatedProgress == 1
            self.progress.setProgress(Float(self.wk.estimatedProgress), animated: true)
            
        }
    }
    
    @IBAction func goBack(sender: AnyObject) {
        self.progress.progress = 0.0
        self.wk.goBack()
    }
    @IBAction func refresh(sender: AnyObject) {
        self.progress.progress = 0.0
        let request = NSURLRequest(URL: self.wk.URL!)
        self.wk.loadRequest(request)
    }
    @IBAction func goForward(sender: AnyObject) {
        self.progress.progress = 0.0
        self.wk.goForward()
    }

    
    //privateMethod
    func someSeletor()
    {
        self.dismissViewControllerAnimated(true) { () -> Void in
            //app调用js
            self.wk.evaluateJavaScript("alert('刘小椿')", completionHandler: nil)
            
        }
    }
    
}
//新建的类
class AAA:NSObject {
    func BBB(){
        print("成功")
    }
}
