//
//  SFFileManager.swift
//  NSSeion-New
//
//  Created by zidon on 16/6/20.
//  Copyright © 2016年 zidon. All rights reserved.
//

import UIKit

class SFFileManager: NSObject ,FileManagerDelegate{
    
    static let sharedInstance:SFFileManager=SFFileManager.init()
    
    @objc let fileManger:FileManager=FileManager.default
    
    override init(){
        super.init()
    }
    ///   保存文件
    func saveFile(data:Data ,toPath:String) {
        if !checkFile(path: toPath) {
            fileManger.createFile(atPath: toPath, contents: data, attributes: [:])
        }
    }
    ///   删除文件
    func deleteFile(path:String)  {
        if checkFile(path: path) {
            try! fileManger.removeItem(at: URL.init(fileURLWithPath: path))
        }
    }
    ///   拷贝文件
    func copy(path:String,  toPath:String) {
        
        let str="这是一段经典的旋律"
        let ppp:String=SFFileManager.getPath(name: "/test.txt", pathType: FileManager.SearchPathDirectory.cachesDirectory)
        try! str.write(toFile: ppp, atomically: true, encoding: String.Encoding.utf8)
        
        let ddd=SFFileManager.getPath(name: "/test.txt", pathType: FileManager.SearchPathDirectory.documentDirectory)
        //拷贝 文件名字要一样
        if self.checkFile(path: ddd) {
            self.deleteFile(path: ddd)
        }
        try! fileManger.copyItem(atPath: ppp, toPath: ddd)
        
        
        let weakSelf=weakMe(swiftObj: self)
        
        self.asyncDo { 
            let fileHand=try! FileHandle.init(forReadingFrom: URL.init(fileURLWithPath: path))
            /// FileHandle没有创建文件的功能，所以要先用fileManager先创建好文件
            weakSelf.fileManger.createFile(atPath: toPath, contents: nil, attributes: [:])
            let data:Data=fileHand.readDataToEndOfFile()
            fileHand.closeFile()
            let fileHandWrite=try! FileHandle.init(forWritingTo: URL.init(fileURLWithPath: toPath))
            fileHandWrite.write(data)
            fileHandWrite.closeFile()
        }
    }
    ///   移动文件
    func move(path:String, toPath:String)  {
        if checkFile(path: path) {
            try! fileManger.moveItem(at: URL(string: path)!, to: URL(string: toPath)!)
        }
    }
    ///   拷贝数据
    func copy(data:Data ,toPath:String)  {
        
        
        
        
        let weakSelf=weakMe(swiftObj: self)
        self.asyncDo {
            /// FileHandle没有创建文件的功能，所以要先用fileManager先创建好文件
            if weakSelf.checkFile(path: toPath) {
                weakSelf.fileManger.createFile(atPath: toPath, contents: nil, attributes: [:])
            }
            
            var fileHandWrite:FileHandle?

            do {
                fileHandWrite = try FileHandle.init(forWritingTo: URL.init(fileURLWithPath: toPath))
            } catch _ {
                print("报错了")
            }
            
            fileHandWrite?.write(data)
            fileHandWrite?.closeFile()
        }
    }
    
    func getData(fromPath:String) ->Data? {
        if !checkFile(path: fromPath) {
            return nil
        }
        let fileHandRead:FileHandle=FileHandle.init(forReadingAtPath: fromPath)!
        let data:Data=fileHandRead.readDataToEndOfFile()
        return data
    }
    
    class func getPath(name:String ,pathType:FileManager.SearchPathDirectory) -> String {
        var path:String=NSSearchPathForDirectoriesInDomains(
            pathType, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        path=path + name
        return path
    }
    
    @objc func checkFile(path:String) -> Bool {
        return fileManger.fileExists(atPath: path)
    }
}
