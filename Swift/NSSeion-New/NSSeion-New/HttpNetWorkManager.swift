//
//  HttpNetWorkManager.swift
//  NSSeion-New
//
//  Created by zidon on 15/10/29.
//  Copyright © 2015年 zidon. All rights reserved.
//

import UIKit

//类的扩展
extension String {
    var nsdata: Data {
        return self.data(using: String.Encoding.utf8)!
    }
}

class HttpNetWorkManager: NSObject {
    
    class func postRequest(_ url:String,params:NSDictionary,complete:([String:AnyObject],NSError) -> Void){
        let getUrlString=url+"?"+Serilize.buildParams(params as! [String : AnyObject])
        let operation=HttpRequestOperation.swiftSharedInstance
        operation.getWithUrl(getUrlString) { (dict) in
            
        }
    }
    
    class func getRequest(_ url:String,params:NSDictionary,complete:([String:AnyObject],NSError) -> Void){
        let operation=HttpRequestOperation.swiftSharedInstance
        operation.postRequest(url, httpBodyData: Serilize.buildParams(params as! [String : AnyObject]).nsdata) { (dict) in
            
        }
    }
    
    class func downLoadRequest(_ url:String,progress:@escaping (_ progress:Int64,_ expectLarge:Int64) ->Void,completeDownLoad:@escaping (_ error:NSError?) -> Void){
        let operation=HttpRequestOperation.swiftSharedInstance
        operation.downLoadRequest(url, progress: progress, completeDownLoad: completeDownLoad)
    }
}

class Serilize: NSObject {
    class func buildParams(_ parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        for key in Array(parameters.keys).sorted(by: <) {
            let value: AnyObject! = parameters[key]
            components += queryComponents(key, value)
        }
        let formattString=(components.map{"\($0)=\($1)"} as [String]).joined(separator: "&")
        return formattString
    }
    
    class func queryComponents(_ key: String, _ value: AnyObject) -> [(String, String)] {
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
    class func escape(_ string: String) -> String {
        let legalURLCharactersToBeEscaped: CFString = ":&=;+!@#$()',*" as CFString
        return CFURLCreateStringByAddingPercentEscapes(nil, string as CFString!, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
}
