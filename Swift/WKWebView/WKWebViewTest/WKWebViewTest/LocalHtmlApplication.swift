//
//  LocalHtmlApplication.swift
//  WKWebViewTest
//
//  Created by zidon on 16/5/16.
//  Copyright © 2016年 zidon. All rights reserved.
//

import UIKit
import WebKit

typealias mimeTypeClose = (String) -> Void

class LocalHtmlApplication: UIViewController,WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate {
    lazy var wkWebView:WKWebView!={
        
        // 创建一个webiview的配置项
        let configuretion = WKWebViewConfiguration()
        
        // Webview的偏好设置
        configuretion.preferences = WKPreferences()
        configuretion.preferences.minimumFontSize = 20
        configuretion.preferences.javaScriptEnabled = true
        // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
        configuretion.preferences.javaScriptCanOpenWindowsAutomatically = false
        // 添加一个JS到HTML中，这样就可以直接在JS中调用我们添加的JS方法
        let script = WKUserScript(source: "func('hello world','这个是oc给js传的参数')",
                                  injectionTime: .AtDocumentStart,// 在载入时就添加JS
            forMainFrameOnly: true) // 只添加到mainFrame中
        
        configuretion.userContentController=WKUserContentController()
        configuretion.userContentController.addScriptMessageHandler(self, name: "AppModel")
        configuretion.userContentController.addUserScript(script)

        let wkWebView=WKWebView.init(frame: CGRectMake(0, 64+60, self.view.bounds.size.width, self.view.bounds.size.height-64-60), configuration: configuretion)
        wkWebView.UIDelegate=self
        wkWebView.navigationDelegate=self
        return wkWebView
    }()
    
    lazy var userContentVc:WKUserContentController!={
        return WKUserContentController()
    }()
    
    override func viewDidLoad() {
        
        view.backgroundColor=UIColor.greenColor()
        
        let path=NSBundle.mainBundle().pathForResource("xml", ofType: "html")
        let url=NSURL.fileURLWithPath(path!)
        let data=NSData.init(contentsOfFile: path!)
        
        weak var wself=self
        self.getMIMEType(url) { (mimeType) in
            
            wself!.wkWebView.loadData(data!, MIMEType: mimeType, characterEncodingName: "utf-8", baseURL: url)
            wself!.view.addSubview(wself!.wkWebView)
        }
        
        let btn=UIButton.init(type: .Custom)
        
        btn.backgroundColor=UIColor.grayColor()
        btn.frame=CGRectMake(15, 64+15, 80, 30)
        btn.setTitle("调用js", forState: .Normal)
        btn.addTarget(self, action: #selector(self.callJs(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(btn)
    }
    
    func callJs(btn:UIButton) {
        //调用js代码
        wkWebView.evaluateJavaScript("funcwww('改变按钮的文字')") { (unknow, error) in
            print("调用完成",unknow)
        }
    }
    
    func getMIMEType(urlString:NSURL!, mimeType:mimeTypeClose) {
        let urlSession=NSURLSession.sharedSession()
        let sessionDataTask=urlSession.dataTaskWithURL(urlString) { (data, response, error) in
            //回到主线程
            dispatch_async(dispatch_get_main_queue(), { 
                mimeType((response?.MIMEType)!)
            })
        }
        sessionDataTask.resume()
    }
    ///WKNavigationDelegate
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void){
        //允许前进才可以
        decisionHandler(WKNavigationActionPolicy.Allow)
        
        if navigationAction.request.URL?.scheme=="objc" {
            //去掉协议
            let path=navigationAction.request.URL?.absoluteString.substringFromIndex("objc://".endIndex)
            print("去掉协议的路径:",path)
            //获取参数
            let capture:Array<String>=(path?.componentsSeparatedByString("?"))!
            print("参数:",capture)
            //获取方法名
            let selectorString=capture[0].stringByReplacingOccurrencesOfString("_", withString: ":")
            let sel=NSSelectorFromString(selectorString)
            
            print(capture[1])
            let params:Array<String>=capture[1].componentsSeparatedByString("&")
            
            //利用map把"a"都去掉
            self.performSelector(sel, withObject:params.map({
                (paraStr:String) -> String in
                return paraStr.substringFromIndex(paraStr.startIndex.successor())
            }))
        }
    }
    
    func ocFunc(params:Array<String>) {
        print("js调用oc传递的参数:",params,params[1])
    }
    
    func webView(webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!){
        
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void){
        
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        
    }
    
//    func webView(webView: WKWebView, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void){
//        print("lala")
//    }
    
        
    ///WKUIDelegate
    ///弹出alert的回调
    func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void) {
        print("runJavaScriptAlertPanelWithMessage")
        self.alertNewAPI("弹出", message: message, buttonTitles: ["取消","确定"]) { (index) in
            completionHandler()
        }
    }
    
    ///弹出确定窗口的回调
    func webView(webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: (Bool) -> Void) {
        print("runJavaScriptConfirmPanelWithMessage")
        self.alertNewAPI("弹出", message: message, buttonTitles: ["取消","确定"]) { (index) in
            completionHandler(true)
        }
    }
    
    func webView(webView: WKWebView, createWebViewWithConfiguration configuration: WKWebViewConfiguration, forNavigationAction navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        print("createWebViewWithConfiguration")
        return wkWebView
    }
    
    ///WKScriptMessageHandler 代理
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage){
        print("userContentController")
    }

}
