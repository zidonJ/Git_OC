//
//  ViewController.swift
//  WebCallNative
//
//  Created by zidonj on 2018/11/19.
//  Copyright © 2018 langlib. All rights reserved.
//

import UIKit
import WebKit


typealias mimeTypeClose = (String) -> Void

class ViewController: UIViewController ,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UIScrollViewDelegate {
    
    var webView:WKWebView!
    // 创建一个webiview的配置项
    let configuretion = WKWebViewConfiguration()
    let userContentController = WKUserContentController()
    // Webview的偏好设置
    let wkPreferences = WKPreferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        WXApi.registerApp("wx83ef7d226bbcd978", enableMTA: true)

        wkPreferences.minimumFontSize = 0
        wkPreferences.javaScriptEnabled = true
        wkPreferences.javaScriptCanOpenWindowsAutomatically = true
        configuretion.preferences = wkPreferences
        
        configuretion.allowsInlineMediaPlayback = true
        configuretion.requiresUserActionForMediaPlayback = true
        configuretion.mediaTypesRequiringUserActionForPlayback = .video
        configuretion.allowsPictureInPictureMediaPlayback = true
        configuretion.applicationNameForUserAgent = "WebCallNative"
                
        // 添加一个JS到HTML中这样就可以直接在JS中调用我们添加的JS方法 在载入时就添加JS 只添加到mainFrame中
        
        let scripts = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        
        let script = WKUserScript(source: scripts ,injectionTime: .atDocumentEnd,forMainFrameOnly: true)
        configuretion.userContentController.addUserScript(script)
        
        webView = WKWebView(frame: view.bounds, configuration: configuretion)
        webView.scrollView.delegate = self;
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        //jsCallSwift 1.html
        //IOS popularize.html
        webView.configuration.userContentController.add(self, name:"jsCallSwift" )
        
        userContentController.add(self, name: "jsCallSwift")
        configuretion.userContentController = userContentController
        
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "1", ofType: "html") ?? "")
//        let url:URL = URL(string: "https://www.bilibili.com/video/av93064439?spm_id_from=333.851.b_7265706f7274466972737431.7")!
//        webView.load(URLRequest.init(url: url))
//        view.addSubview(webView)
        let data:Data = try! Data(contentsOf: url)
        getMIMEType(urlString: url) {
            [weak self] (mimeType) in
            guard let strongSelf = self else {
                return;
            }
            strongSelf.webView.load(data, mimeType: mimeType, characterEncodingName: "utf-8", baseURL: url)
            strongSelf.view.addSubview(strongSelf.webView)
        }
        
        
        print("start methodList")
        var methodNum:UInt32 = 0
        guard let methodList = class_copyMethodList(ViewController.classForCoder(), &methodNum) else {
            return
        }
        
        for index in 0..<numericCast(methodNum){
            let method:Method = methodList[index]
            print(String(_sel:method_getName(method)))
            guard let cstring = method_getTypeEncoding(method) else {
                return
            }
            print("type:",String(cString: cstring))
            
        }
        print("end methodList")
    }
    
    //MARK:--   private func
    func getMIMEType(urlString:URL, mimeType:@escaping mimeTypeClose) {
        
        let urlSession = URLSession.shared
        let sessionDataTask = urlSession.dataTask(with: urlString) { (data, response, error) in
            
            let mainQueue = DispatchQueue.main
            mainQueue.async {
                mimeType(response?.mimeType ?? "")
            }
        }
        sessionDataTask.resume()
    }
    
    //MARK:--   delegate
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        decisionHandler(WKNavigationActionPolicy.allow)
        
        if navigationAction.request.url?.absoluteString.hasPrefix("objc") ?? false {
            
            guard let path = navigationAction.request.url?.absoluteString else {
                return;
            }
            
            let str:String = path.substring(from: "objc://".count)
            
            //获取参数
            var capture:Array<String> = str.components(separatedBy: "?")
            let params:Array<String> = capture[1].components(separatedBy: "&")
            perform(#selector(ViewController.ocFunc(params:)), with: params)
            
        }
    }
    
    ///WKScriptMessageHandler 与js交互
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        print("^^^^",message.name,message.body)
    }
    
    func test() -> Bool {
        
        return true
//        let launchMiniProgramReq = WXLaunchMiniProgramReq.object()
//        launchMiniProgramReq?.userName = "gh_ba9c8a92f95e";  //拉起的小程序的username
//        launchMiniProgramReq?.path = "/pages/book/index";    //拉起小程序页面的可带参路径,不填默认拉起小程序首页
//        launchMiniProgramReq?.miniProgramType = .release; //拉起小程序的类型
//        return  WXApi.send(launchMiniProgramReq)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("滚动了")
    }
    
    @objc func ocFunc(params : Array<String>) {
        print("js调用oc传递的参数:",params,params[1])
        
        print(test())        
    }
    
}

extension String {
    public func substring(from index: Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]
            
            return String(subString)
        } else {
            return self
        }
    }
}

