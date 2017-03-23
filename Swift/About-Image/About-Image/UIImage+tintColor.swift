//
//  UIImage+tintColor.swift
//  About-Image
//
//  Created by zidonj on 2017/3/23.
//  Copyright © 2017年 zidon. All rights reserved.
//

import UIKit

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
        
        let width = cgImage!.width / 2
        let height = cgImage!.height / 2
        let bitsPerComponent = cgImage?.bitsPerComponent
        let bytesPerRow = cgImage?.bytesPerRow
        let colorSpace = cgImage?.colorSpace
        let bitmapInfo = cgImage?.bitmapInfo
        
        let context:CGContext = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent!, bytesPerRow: bytesPerRow!, space: colorSpace!, bitmapInfo: bitmapInfo!.rawValue)!
        context.interpolationQuality = CGInterpolationQuality.high
        context.draw(cgImage!, in: CGRect.init(origin: CGPoint.zero, size: size))
        let resizeImage = context.makeImage().flatMap({
            UIImage.init(cgImage: $0)
        })!
        return resizeImage
    }
    
    
}
