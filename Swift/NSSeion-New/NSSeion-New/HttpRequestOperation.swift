//
//  HttpRequestOperation.swift
//  NSSeion-New
//
//  Created by zidon on 15/10/29.
//  Copyright © 2015年 zidon. All rights reserved.
//

import UIKit
import Foundation
import ObjectiveC.runtime

typealias completed = ([String:AnyObject],NSError) -> Void
typealias downLoadProgress = (_ progress:Int64,_ expectLarge:Int64) -> Void
typealias downLoaded = (_ error:NSError?) -> Void

let blockKey:String="blockKey"

class HttpRequestOperation: NSObject,URLSessionDataDelegate,URLSessionDownloadDelegate {
    
    var path:String!
    var finishDownLoad:downLoaded!
    //下载进度
    var progressDownLoad:downLoadProgress!
    
    lazy var outPutStream:OutputStream={
        [weak self] in
        self?.path=NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        self?.path=(self?.path)! + "/temp.mp4"
        //append为true是每次都写到文件末尾
        let outPutStream=OutputStream.init(toFileAtPath:(self?.path!)!, append: true)!
        outPutStream.open()
        return outPutStream
    }()
    
    lazy var session:URLSession={
        [weak self] in
        let session:URLSession=Foundation.URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        session.sessionDescription = "in-process NSURLSession";
        return session
    }()
    
    var task:URLSessionDownloadTask?=nil
    
    
    //更简单的单利
    static let swiftSharedInstance=HttpRequestOperation()
    
    override init() {
        super.init()
    }
    
    func getWithUrl(_ url:String,resopnse:@escaping completed){
        self.realRequest(url, method: "GET", httpBody: nil) { (data,error) in
            resopnse(data,error)
        }
    }
    
    func postRequest(_ url:String,httpBodyData:Data,resopnse:@escaping completed){
        self.realRequest(url, method: "POST", httpBody: httpBodyData) { (data,error) in
            resopnse(data,error)
        }
    }
    //普通网络请求
    func realRequest(_ url:String,method:String,httpBody:Data?,resopnse:@escaping completed) {
        var request=URLRequest(url: URL(string: "http://api.xw.feedss.com/news/video")!)
        request.httpMethod=method
        request.httpBody=httpBody
        //开始请求
        let task=session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            let data:[String:AnyObject]=try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : AnyObject]
            resopnse(data,error! as NSError)
        })
        task.resume()
    }
    //下载网络请求
    func downLoadRequest(_ url:String,progress:@escaping downLoadProgress,completeDownLoad:@escaping downLoaded) {
        progressDownLoad=progress
        finishDownLoad=completeDownLoad
        let request=URLRequest(url: URL(string: "http://mami.wxwork.cn//public//js//test1.mp4")!)
        
        //使用闭包的时候 'NSURLSessionDownloadDelegate' 代理不会执行
        self.session.downloadTask(with: request) { (url, response, error) in
            completeDownLoad(error as NSError?)
            print(url ?? "空",#line)
        }
        
        //这种方式下载，使用代理
//        let path:String = SFFileManager.getPath(name: "/temp.mp4", pathType: FileManager.SearchPathDirectory.cachesDirectory)
//        let data:Data? = SFFileManager.sharedInstance.getData(fromPath: path)
//        
//        if data != nil {
//            session.downloadTask(withResumeData: data!)
//        }else{
//            task=session.downloadTask(with: request)
//            task?.resume()
//        }
    }
    
    func suspendDownLoad() {
        task?.cancel { (data) in
            SFFileManager.sharedInstance.copy(data: data!, toPath: SFFileManager.getPath(name: "/temp.mp4", pathType: FileManager.SearchPathDirectory.cachesDirectory))
        }
    }
    
    ///NSURLSessionDataDelegate
    private func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: (URLSession.ResponseDisposition) -> Void)
    {
        print("456")
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data)
    {
        print("Receive data:")
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask)
    {
        print("123")
    }
    
    //NSURLSessionDownloadDelegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    {
        self.progressDownLoad(totalBytesWritten,totalBytesExpectedToWrite)
    }
    //从某位移处重新开始下载
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64)
    {
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL){
        ///location这里自带“file://”路径 转成字符串后不能用URL.init(fileURLWithPath: String)初始化
        //self.outPutStream.close()
        
        print(location,#line)
        
        //        var byteArray:[UInt8] = [UInt8]()
        //        for i in 0..<data.count {
        //            var temp:UInt8 = 0
        //
        //            data.copyBytes(to: &temp, from: Range(uncheckedBounds: (lower: i, upper: 1)))
        //            byteArray.append(temp)
        //        }
        //
        //        self.outPutStream.write(byteArray, maxLength: data.count)
        //        //任务完成使session失效
        //        session.finishTasksAndInvalidate()
        
//        let fileHand=try! FileHandle.init(forReadingFrom: location)
//        
//        let data:Data=fileHand.readDataToEndOfFile()
//        fileHand.closeFile()
//        SFFileManager.sharedInstance.copy(data: data,
//                                        toPath: SFFileManager.getPath(name: "/temp.mp4", pathType: FileManager.SearchPathDirectory.cachesDirectory))
        
    }
}

