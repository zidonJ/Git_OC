//
//  ViewController.swift
//  WKWebViewTest
//
//  Created by zidon on 16/3/3.
//  Copyright © 2016年 zidon. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class ViewController: UIViewController,SFSafariViewControllerDelegate,WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate
{
    private var urlString:String = "https://www.baidu.com"
    var webView:WKWebView?
    var userContentController:WKUserContentController?
    //MARK: Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func wkwebviewshow(sender: UIButton) {
        
//        self.userContentController=WKUserContentController.init()
//        let cookieScript=WKUserScript.init(source: "document.cookie = 'TeskCookieKey1=TeskCookieValue1';document.cookie = 'TeskCookieKey2=TeskCookieValue2'", injectionTime: WKUserScriptInjectionTime.AtDocumentStart, forMainFrameOnly: false)
//        self.userContentController!.addUserScript(cookieScript)
//        
//        let webViewConfiguration=WKWebViewConfiguration.init()
//        webViewConfiguration.userContentController=self.userContentController!
//        self.webView=WKWebView.init(frame: self.view.bounds, configuration: webViewConfiguration)
//        self.view.addSubview(self.webView!)
//        
//        // 图片缩放的js代码
//        let js = "var count = document.images.length;for (var i = 0; i < count; i++) {var image = document.images[i];image.style.width=320;};window.alert('找到' + count + '张图');";
//        // 根据JS字符串初始化WKUserScript对象
//        let script=WKUserScript.init(source: js, injectionTime: WKUserScriptInjectionTime.AtDocumentEnd, forMainFrameOnly: true)
//        // 根据生成的WKUserScript对象，初始化WKWebViewConfiguration
//        let config=WKWebViewConfiguration()
//        config.userContentController.addUserScript(script)
//        
//        self.webView!.loadHTMLString("<head></head><img src='http://www.nsu.edu.cn/v/2014v3/img/background/3.jpg' />", baseURL: nil)
        
        
        self.webView=WKWebView.init(frame: self.view.bounds)
        self.webView!.UIDelegate=self
        self.webView!.navigationDelegate=self
        let url = NSURL(string: "http://www.baidu.com")
        let request = NSURLRequest(URL: url!)
        self.webView!.loadRequest(request)
        self.view.addSubview(self.webView!)
        
    }
    //MARK: Web Content Presenting
    @IBAction func openInSafari(sender: AnyObject)
    {
        //TODO: Open in native safari
        let url = NSURL(string: self.urlString)!
        UIApplication.sharedApplication().openURL(url)
    }
    
    @IBAction func openWithSafariVC(sender: AnyObject)
    {
        //TODO: Open in safari view controller
        let svc = SFSafariViewController(URL: NSURL(string: "http://www.baidu.com")!)
        svc.delegate=self
        self.presentViewController(svc, animated: true, completion: nil)
    }
    
    @IBAction func loadHtml(sender: UIButton) {
        let vc=storyboard!.instantiateViewControllerWithIdentifier("localHtml")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    ///SFSafariViewControllerDelegate 代理
    //初始地址加载完毕
    func safariViewController(controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        print("初始地址加载完毕","哈哈")
    }
    
    //点击done 完成的时候执行
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        print("执行完毕","哈哈哈哈哈哈哈哈😄")
    }
    
    ///WKScriptMessageHandler 代理
    ///从web界面中接收到一个脚本时调用
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        print("从web界面中接收到一个脚本时调用",":",message)
    }
    
    ///WKNavigationDelegate
    //开始加载页面内容时调用
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("页面开始加载")
    }
    ///内容开始返回时调用
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        print("页面开始返回内容")
    }
    ///页面加载完之后调用
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        print("页面加载完成")
    }
    ///页面加载失败时调用
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        print("页面加载失败")
    }
    
    ///接到服务器跳转请求后调用
    func webView(webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("接到服务器跳转请求后调用")
    }
    
    ///在受到响应后，决定是否跳转
    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
        print("在受到相应后，决定是否跳转",navigationResponse.response.URL!.scheme)
        //允许跳转
        decisionHandler(WKNavigationResponsePolicy.Allow)
    }
    ///在发送请求前决定是否跳转
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.request.URL!.host!.lowercaseString=="m.baidu.com"{
            //允许跳转
            decisionHandler(WKNavigationActionPolicy.Allow)
        }
    }
    
    ///身份验证
//    func webView(webView: WKWebView, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
//        print("身份验证")
//        
//    }
    
    ///WKUIDelegate
    
    /**
    web界面中有弹出警告框时调用
    
    - parameter webView:           实现该代理的webview
    - parameter message:           警告框中的内容
    - parameter frame:             主窗口
    - parameter completionHandler: 警告框消失调用
    */
    func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void) {
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        //TODO: open in webview
    }
}

