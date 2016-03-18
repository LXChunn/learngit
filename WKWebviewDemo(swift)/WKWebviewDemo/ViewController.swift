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
        self.wk = WKWebView(frame: self.view.frame,configuration: conf)
        
        
        self.wk?.navigationDelegate = self
        self.wk?.UIDelegate = self
        
        self.wk.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.baidu.com/")!))
        
//        self.runPluginJS(["Console"])
        self.view.addSubview(self.wk)
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
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        print("启动了。。。")
    }
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!)
    {
        print("didCommitNavigation")
    }
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!)
    {
        print("didFinishNavigation")
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
