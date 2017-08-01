//
//  ViewController.swift
//  NSSeion-New
//
//  Created by zidon on 15/10/27.
//  Copyright © 2015年 zidon. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,URLSessionDataDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //HttpNetWorkManager.getRequest("http://beida.035k.com//api/index/returnPost/", params:["one":"1"])
        
        HttpNetWorkManager.downLoadRequest("", progress: { (progress, expectLarge) in
            print("下载进度是\(progress),文件大小是\(expectLarge)")
        }) { (error) in
            print(error ?? "没有报错")
        }
        
        
        let data1 = Data(bytes: [0x01, 0x02, 0x03])
        data1.withUnsafeBytes { (pointer: UnsafePointer<UInt8>) -> Void in
            print(pointer)
            
            print(pointer.pointee)
        }
        
        _ = data1.withUnsafeBytes { (pointer: UnsafePointer<Int32>) -> Int32 in
            return pointer.pointee
        }
    }
    
    func buildParams(_ parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        for key in Array(parameters.keys).sorted(by: <) {
            let value: AnyObject! = parameters[key]
            components += queryComponents(key, value)
        }
        let formattString=(components.map{"\($0)=\($1)"} as [String]).joined(separator: "&")
        return formattString
    }
    func queryComponents(_ key: String, _ value: AnyObject) -> [(String, String)] {
        var components: [(String, String)] = []
        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents("\(key)", value)
            }
        } else {
            components.append(contentsOf: [(escape(key), escape("\(value)"))])
        }
        
        return components
    }
    
    //去掉非法字符
    func escape(_ string: String) -> String {
        
        return string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    
    @IBAction func getRequest(_ sender: UIButton) {
        let dictionary=["published": "0","type":"1"]
        var request=URLRequest(url: URL(string:"http://beida.035k.com//api/index/returnPost/"+"?"+self.buildParams(dictionary as [String : AnyObject]))!)
        request.httpMethod="GET"
        let session=Foundation.URLSession(configuration: URLSessionConfiguration.default,
            delegate: self, delegateQueue: nil)
        let task=session.dataTask(with: request)
        task.resume()
    }
    
    
    @IBAction func postRequest(_ sender: UIButton) {
        
        let dictionary=["published": "0","type":"1"]
        var request=URLRequest(url: URL(string: "http://api.xw.feedss.com/news/video")!)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let dicHttpTop=["UserAgent":"iphone",
            "channelid":"appstore","deviceid":"02382066-CAD3-4824-8334-DBD38DEE8569","language":"zh_CN","phoneresolution":"750x1334","phonetype":"x86_64","productid":"5.0.0","sdkversion":"9.1","uniqueid":"7064d0217d3d11e5b5810be55b1866b7","userid":"7064d0217d3d11e5b5810be55b1866b7"]
        request.httpMethod="POST"
        //添加请求头配置信息
        for (key,value) in dicHttpTop{
            request.addValue(value, forHTTPHeaderField: key)
        }
        let para=self.buildParams(dictionary as [String : AnyObject])
        request.httpBody=para.data(using: String.Encoding.utf8)
        print(para)
        let session=URLSession(configuration: URLSessionConfiguration.default,
            delegate: self, delegateQueue: nil)
        
        
        let task=session.dataTask(with: request)
        task.resume()
    }
    
    var jsonData=NSMutableData()
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        jsonData.append(data)
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("执行了么",error ?? "请求成功")
        do{
            let dict=try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            
            print(dict)
        }catch{
            print("这是搞些什么奇葩啊")
        }
    }
}

