//
//  FileReadAndWrite.swift
//  StreamAbout
//
//  Created by 姜泽东 on 2018/5/3.
//  Copyright © 2018年 MaiTian. All rights reserved.
//

import UIKit

class FileReadAndWrite:NSObject {
    
    var readBack:((String)->(Void))? = nil
    
    var filePath:String!
    
    var buffer = Data(count: 1024)//Must be large enough for largest message + 4
    var bytesRead = 0//Number of bytes read so far
    
    
    var writeStream:OutputStream?
}

extension FileReadAndWrite {
    
    func readFile(path:String,back:@escaping (String)->(Void)){
        
        readBack = back
        let readStream = InputStream(fileAtPath: filePath!)
        readStream?.delegate = self
        readStream?.schedule(in: RunLoop.current, forMode: .commonModes)
        readStream?.open()
        
        
        var data:Data = try! Data.init(contentsOf: URL.init(fileURLWithPath: filePath))
        data.withUnsafeMutableBytes { (byte:UnsafeMutablePointer<UInt8>) -> Void in
            //let safeBuffer = UnsafeBufferPointer(start: byte, count: data.count)
            //maxLength 缓冲区字节数最大值
            readStream?.read(byte, maxLength: 2)
        }
        
    }
    
    func realRead(aStream: Stream)  {
        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        let read = aStream as! InputStream
        var data:Data = Data()
        while read.hasBytesAvailable {
            
            let read = read.read(buffer, maxLength: bufferSize)
            data.append(buffer, count: read)
        }
        buffer.deallocate()
        read.close()
        let backString = String(data: data, encoding: .utf8)
        
        guard let readCallBack = readBack else {
            return
        }
        readCallBack(backString ?? "")
    }
    
    func writeFile(path:String) {
        
        //Xcode工程文件不能这样写入 需要在沙盒目录自己创建文件
        var path:String = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        path += "/test.txt"
        print("路径:",path)
        let writeStream = OutputStream(toFileAtPath: path, append: true)
        writeStream?.delegate = self
        writeStream?.schedule(in: .current, forMode: .commonModes)
        writeStream?.open()
    }
    
    func realWrite(aStream: Stream) {
        
        writeStream = aStream as? OutputStream
        let writeString = "bzxcaaaaaaaaaabnbnbnbnbnbnbn"
        
//        let dataWrite = writeString.data(using: .utf8)
        
//        dataWrite?.withUnsafeBytes { (byte:UnsafePointer<UInt8>) -> Void in
//
//            writeStream?.write(byte, maxLength: dataWrite!.count)
//            writeStream?.close()
//        }
        
        let readStream = InputStream(fileAtPath: filePath!)
        readStream?.delegate = self
        readStream?.schedule(in: RunLoop.current, forMode: .commonModes)
        readStream?.open()
        writeStream?.writeStream(input: readStream!)
        writeStream?.writeString(string: writeString)
        writeStream?.close()
        readStream?.close()
    }
}

extension FileReadAndWrite : StreamDelegate{
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        
        switch eventCode {
        case Stream.Event.openCompleted:
            print("文件打开完成")
        case Stream.Event.hasBytesAvailable:
            print("hasBytesAvailable")
            realRead(aStream: aStream)
        case Stream.Event.hasSpaceAvailable:
            print("hasSpaceAvailable")
            realWrite(aStream: aStream)
        case Stream.Event.errorOccurred:
            print("errorOccurred")
        case Stream.Event.endEncountered:
            print("endEncountered")
        default:
            break
        }

    }
}
