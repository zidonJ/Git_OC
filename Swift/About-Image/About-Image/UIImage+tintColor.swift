//
//  UIImage+tintColor.swift
//  About-Image
//
//  Created by zidonj on 2017/3/23.
//  Copyright © 2017年 zidon. All rights reserved.
//

import UIKit
import ImageIO

extension UIImage {
    func image(tintColor:UIColor) -> UIImage {
        //destinationIn:D*Sa->目标色和原色透明度的加成
        return self.imageMake(tintColor: tintColor, mode: .destinationIn)
    }
    
    
    func image(gradient:UIColor) -> UIImage {
        //overlay:可以保持背景色的明暗,也就是灰度信息
        return self.imageMake(tintColor: gradient, mode: .overlay)
    }
    
    func imageMake(tintColor:UIColor, mode:CGBlendMode) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        tintColor.setFill()
        let rect = CGRect.init(origin: CGPoint.zero, size: self.size)
        UIRectFill(rect)
        self.draw(in: rect, blendMode: mode, alpha: 1.0)
        if mode != CGBlendMode.destinationIn {
            self.draw(in: rect, blendMode: .destinationIn, alpha: 1.0)
        }
        let imageBlend = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageBlend!
    }
    
    //图片尺寸
    func change(image:UIImage,size:CGSize) -> UIImage {
        let cgImage = image.cgImage

        let bitsPerComponent = cgImage?.bitsPerComponent
        let bytesPerRow = cgImage?.bytesPerRow
        let colorSpace = cgImage?.colorSpace
        let bitmapInfo = cgImage?.bitmapInfo
        
        let context:CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: bitsPerComponent!, bytesPerRow: bytesPerRow!, space: colorSpace!, bitmapInfo: bitmapInfo!.rawValue)!
        context.interpolationQuality = CGInterpolationQuality.high
        context.draw(cgImage!, in: CGRect.init(origin: CGPoint.zero, size: size))
        let resizeImage = context.makeImage().flatMap({
            UIImage.init(cgImage: $0)
        })!
        return resizeImage
    }
    
    func changeIO(image:UIImage,size:CGSize) -> UIImage? {
        let urlString:String = Bundle.main.path(forResource: "1", ofType: "jpg")!
        let url:URL = URL.init(fileURLWithPath: urlString)
        if let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) {
            let options: [String: Any] = [
                kCGImageSourceThumbnailMaxPixelSize as String: max(size.width, size.height) / 2.0,
                kCGImageSourceCreateThumbnailFromImageAlways as String: true
            ]
            
            let scaledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary?).flatMap { UIImage(cgImage: $0) }
            return scaledImage
        }
        return nil
    }
    
    func changeUIKit(image:UIImage ,size:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        image.draw(in: CGRect.init(origin: CGPoint.zero, size: size))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizeImage
    }
}

//滤镜
extension UIImage {
    //人脸马赛克
    func pixe(image:UIImage ,level:Int) -> UIImage {
        return self
    }
}

typealias clickColor = (_ color:UIColor) -> Void

extension UIImageView {
    
    static let pointee = UnsafeRawPointer.init(bitPattern: 1)
    
    //取色
    func getColor(color:clickColor) {
        self.isUserInteractionEnabled = true
        objc_setAssociatedObject(self, UIImageView.pointee!, color, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    func free() {
        objc_removeAssociatedObjects(self)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point = touch?.location(in: self)
        let x=ceil((point?.x)!)
        let y=ceil((point?.y)!)
        
        UIGraphicsBeginImageContext((self.image?.size)!)
        let ctx=UIGraphicsGetCurrentContext()
        
        self.image?.draw(in: CGRect.init(x: 0, y: 0, width: (self.image?.size.width)!, height: (self.image?.size.height)!))
        ctx!.setLineWidth(3)
        
        //视图坐标到图片距离的转换（只适用于ScaleAspectFit的存在）
        
        let scale=min(self.bounds.size.width / self.image!.size.width,
                      self.bounds.size.height / self.image!.size.height)
        
        let offsetX=(self.bounds.size.width - self.image!.size.width * scale) / 2.0
        let offsetY=(self.bounds.size.height - self.image!.size.height * scale) / 2.0
        
        let pixelRect=CGRect(x:(x-offsetX)/scale, y:(y-offsetY)/scale, width:30/scale, height:30/scale)
        
        ctx!.addRect(pixelRect)
        UIColor.red.set()
        ctx!.drawPath(using: CGPathDrawingMode.stroke)
        //需要获取图片的时候可以使用
        //let imgNew = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let excatPoint=CGPoint(x:(x-offsetX)/scale, y:(y-offsetY)/scale)
        let tuple = self.getPixelColor(pos: excatPoint)
        let color = UIColor.init(red: tuple.red, green: tuple.green, blue: tuple.blue, alpha: tuple.alpha)
        (objc_getAssociatedObject(self, UIImageView.pointee) as! clickColor)(color)
    }
    
    //获取图片中某点的像素值,函数的返回值是一个元组
    func getPixelColor(pos:CGPoint)->(alpha: CGFloat, red: CGFloat, green: CGFloat,blue:CGFloat){
        let pixelData=self.image?.cgImage!.dataProvider!.data
        let data:UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let pixelInfo: Int = ((Int(self.image!.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return (a,r,g,b)
    }
}








