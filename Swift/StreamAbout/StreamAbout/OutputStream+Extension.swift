//
//  OutputStream+Extension.swift
//  StreamAbout
//
//  Created by 姜泽东 on 2018/5/4.
//  Copyright © 2018年 MaiTian. All rights reserved.
//

import UIKit


extension OutputStream {
    
    ///data写入
    func bwriteData(data:Data) {
        let bufferSize:Int = 1024 * 4;
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        
        var bytesCopied:Int = 0;
        
        while bytesCopied < data.count {

            let bytesToCopy = min(bufferSize, data.count - bytesCopied);
            //将数据拷贝到buffer
            data.copyBytes(to: buffer, from: Range(NSRange(location: bytesCopied, length: bytesToCopy))!)
            
            var bytesWritten:Int = 0;
            while bytesWritten < bytesToCopy {

                let written:Int = write(buffer, maxLength: bytesToCopy - bytesWritten)
                bytesWritten += written;
            }
            bytesCopied += bytesToCopy
        }
        buffer.deallocate()
    }
    
    func pWriteData(data:Data) {
        
        data.withUnsafeBytes { (byte:UnsafePointer<UInt8>) -> Void in
            
            write(byte, maxLength: data.count)
            close()
        }
    }
    
    
    /// 字符串写入
    func writeString(string:String) {
        
        bwriteData(data: string.data(using: .utf8)!)
    }
    
    
    /// 利用读取流写入
    /// - Parameter input: 读取流
    func writeStream(input:InputStream) {
        
        let bufferSize:Int = 1024 * 4;
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        
        while (true) {
            //将数据读入到buffer
            let bytesRead:Int = input.read(buffer, maxLength: bufferSize)
            
            if bytesRead == -1 || bytesRead == 0{
                break;
            }
            
            var bytesWritten:Int = 0;
            
            while bytesWritten < bytesRead {
                
                bytesWritten += write(buffer, maxLength: bytesRead - bytesWritten)
            }
        }
    }
}

