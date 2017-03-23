//
//  ViewController.swift
//  About-Image
//
//  Created by zidonj on 2017/3/22.
//  Copyright © 2017年 zidon. All rights reserved.
//

import UIKit
import ImageIO


class ViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let image:UIImage = UIImage.init(named: "image")!
        var resizeImage:UIImage
        
        //改变图片尺寸1-->UIKit
        let size = __CGSizeApplyAffineTransform(image.size, CGAffineTransform.init(scaleX: 0.5, y: 0.5))
        
//        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
//        image.draw(in: CGRect.init(origin: CGPoint.zero, size: size))
//        resizeImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        imgView.image=resizeImage
        
        
        //改变图片尺寸2-->Core Graphic
//        let cgImage = image.cgImage
//        
//        let width = cgImage!.width / 2
//        let height = cgImage!.height / 2
//        let bitsPerComponent = cgImage?.bitsPerComponent
//        let bytesPerRow = cgImage?.bytesPerRow
//        let colorSpace = cgImage?.colorSpace
//        let bitmapInfo = cgImage?.bitmapInfo
//        
//        let context:CGContext = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent!, bytesPerRow: bytesPerRow!, space: colorSpace!, bitmapInfo: bitmapInfo!.rawValue)!
//        context.interpolationQuality = CGInterpolationQuality.high
//        context.draw(cgImage!, in: CGRect.init(origin: CGPoint.zero, size: size))
//        resizeImage = context.makeImage().flatMap({
//            UIImage.init(cgImage: $0)
//        })!
        //imgView.image=resizeImage
        
        //改变图片尺寸3-->Image I/O
//        let urlString:String = Bundle.main.path(forResource: "1", ofType: "jpg")!
//        let url:URL = URL.init(fileURLWithPath: urlString)
//        if let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) {
//            let options: [String: Any] = [
//                kCGImageSourceThumbnailMaxPixelSize as String: max(size.width, size.height) / 2.0,
//                kCGImageSourceCreateThumbnailFromImageAlways as String: true
//            ]
//            
//            let scaledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary?).flatMap { UIImage(cgImage: $0) }
//            imgView.image = scaledImage
//        }
        
//        imgView.image=image.image(tintColor: UIColor.orange)
        imgView.image=image.image(gradient: UIColor.orange)
    }


}

