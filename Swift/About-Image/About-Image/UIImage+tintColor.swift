//
//  UIImage+tintColor.swift
//  About-Image
//
//  Created by zidonj on 2017/3/23.
//  Copyright © 2017年 zidon. All rights reserved.
//

import UIKit
import ImageIO
import CoreImage

//MARK:extension UIImage颜色
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
}

//MARK:extension UIImage尺寸
extension UIImage {
    //core graphics
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
    //Image I/O
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
    //UIKit
    func changeUIKit(image:UIImage ,size:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        image.draw(in: CGRect.init(origin: CGPoint.zero, size: size))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizeImage
    }
}

//MARK:extension UIImage滤镜(CIFilter)
extension UIImage {
    
    static let detector:CIDetector = CIDetector.init(ofType: CIDetectorTypeFace,
                                                      context: nil,
                                                      options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
    
    func fullPixe(image:UIImage) -> CIImage {
        let ciImage:CIImage = CIImage.init(image: image)!
        let rect:CGRect = ciImage.extent
        let centerX:CGFloat = rect.origin.x + rect.size.width/2
        let centerY:CGFloat = rect.origin.y + rect.size.height/2
        
        let scale:CGFloat = max(rect.size.width, rect.size.height)*image.scale/60
        
        let cifilter:CIFilter = CIFilter.init(name: "CIPixellate",
                                              withInputParameters:[kCIInputImageKey:ciImage.clampingToExtent(),
                                                                   kCIInputScaleKey:NSNumber.init(value: Float(scale)),
                                                                   kCIInputCenterKey:CIVector.init(x: centerX, y: centerY)])!
        
        return (cifilter.outputImage?.cropping(to: ciImage.extent))!
    }
    
    //人脸马赛克
    func pixeFace(image:UIImage) -> UIImage {
        
        let ciImage:CIImage = CIImage.init(image: image)!
        let features:Array<CIFeature> = UIImage.detector.features(in: ciImage)
        print("识别到人脸的个数:",features.count)
        
        var berthArray:Array<Any> = []
        
        for face in features {
            let faceViewBounds:CGRect = ((face as? CIFaceFeature)?.bounds(image: image))!
            let berth:UIBezierPath = UIBezierPath.init(ovalIn: faceViewBounds)
            berthArray.append(berth)
        }
        
        UIGraphicsBeginImageContext(self.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.lightGray.cgColor)
        context.fill(CGRect.init(origin: CGPoint.zero, size: self.size))
        UIColor.white.setFill()
        UIColor.white.setStroke()
        for path in berthArray {
            (path as! UIBezierPath).stroke()
            (path as! UIBezierPath).fill()
        }
        let tempImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let mask_ciImage:CIImage = CIImage.init(image: tempImage!)!
        let back_ciImage:CIImage = ciImage
        let cifliter:CIFilter = CIFilter.init(name: "CIBlendWithMask",
                                               withInputParameters: [kCIInputImageKey:self.fullPixe(image: image),
                                                                     kCIInputMaskImageKey:mask_ciImage,
                                                                     kCIInputBackgroundImageKey:back_ciImage])!
        let resultciImage:CIImage = cifliter.outputImage!
        
        let cicontext:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = cicontext.createCGImage(resultciImage, from: resultciImage.extent)!
        let finalImage:UIImage = UIImage.init(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
        
        return finalImage
    }
}

//MARK:path 效果
extension UIImageView {
    
    
    
}

class PathOverlayView: UIView {
    
}

//MARK:extension UIImageView 获取图片某点颜色
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

//MARK:CIFaceFeature extension
extension CIFaceFeature {
    func bounds(image:UIImage) -> CGRect {
        return self.bounds(image: image, rect: self.bounds)
    }
    
    func bounds(image:UIImage,rect:CGRect) -> CGRect {
        var point:CGPoint = self.point(image: image, origin: rect.origin)
        let size:CGSize = self.size(image: image, size: rect.size)
        
        switch image.imageOrientation {
        case .up:
            point.y -= size.height
            break
        case .down:
            point.x -= size.width
            break
            
        case .left:
            point.x -= size.width
            point.y -= size.height
            break
        case .right:
            break
        case .upMirrored:
            point.x -= size.width
            point.y -= size.height
            break
        case .downMirrored:
            break
        case .leftMirrored:
            point.x -= size.width
            point.y += size.height
            break
            
        case .rightMirrored:
            point.y -= size.height
            break
        }
        
        return CGRect.init(x: point.x, y: point.y, width: size.width, height: size.height)
    }
    
    func point(image:UIImage,origin:CGPoint) -> CGPoint {
        let imageW:CGFloat = image.size.width
        let imageH:CGFloat = image.size.height
        
        var resultPoint:CGPoint = CGPoint()
        
        switch image.imageOrientation {
        case .up:
            resultPoint.x = origin.x
            resultPoint.y = imageH - origin.y
            break
        case .down:
            resultPoint.x = imageW - origin.x
            resultPoint.y = origin.y
            break
            
        case .left:
            resultPoint.x = imageW - origin.y
            resultPoint.y = imageH - origin.x
            break
        case .right:
            resultPoint.x = origin.y
            resultPoint.y = origin.x
            break
        case .upMirrored:
            resultPoint.x = imageW - origin.x
            resultPoint.y = imageH - origin.y
            break
        case .downMirrored:
            resultPoint = origin
            break
        case .leftMirrored:
            resultPoint.x = imageW - origin.y
            resultPoint.y = origin.x
            break
            
        case .rightMirrored:
            resultPoint.x = origin.y
            resultPoint.y = imageH - origin.x
            break
        }
        return resultPoint
    }
    
    func size(image:UIImage,size:CGSize) -> CGSize {
        
        var resultSize:CGSize = CGSize()
        switch image.imageOrientation {
        case .up,.down,.upMirrored,.downMirrored:
            resultSize = size
            break
            
        case .left,.right,.leftMirrored,.rightMirrored:
            resultSize.width = size.height
            resultSize.height = size.width
            break
            
        }
        return resultSize
    }
}
