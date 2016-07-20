//
//  ViewController.swift
//  获取图片中的点
//
//  Created by zidon on 16/4/27.
//  Copyright © 2016年 zidon. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,mediumViewDelegate{
    
    var imgView:UIImageView? = nil
    let image=UIImage.init(named: "1.jpg")!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imgView=UIImageView.init(frame: view.bounds)
        imgView!.image=image
        imgView?.contentMode=UIViewContentMode.ScaleAspectFit
        view.addSubview(imgView!)
        
        let midView=mediumView.init(testPara: 5, frame: view.bounds)
        midView.delegate=self
        view.addSubview(midView)
        
//        let cgMidView=cgMediumView.init(frame: view.bounds)
//        view.addSubview(cgMidView)
    }
    
    func touchPoint(point: CGPoint!) {
        let x=ceil((point?.x)!)
        let y=ceil((point?.y)!)
        
        UIGraphicsBeginImageContext(imgView!.image!.size)
        let ctx=UIGraphicsGetCurrentContext()
        imgView?.image?.drawInRect(CGRectMake(0, 0, imgView!.image!.size.width, imgView!.image!.size.height))
        CGContextSetLineWidth(ctx, 3)
        
        //视图坐标到图片距离的转换（只适用于ScaleAspectFit的存在）
        
        let scale=min(imgView!.bounds.size.width / imgView!.image!.size.width,
            imgView!.bounds.size.height / imgView!.image!.size.height)
        
        let offsetX=(imgView!.bounds.size.width - imgView!.image!.size.width * scale) / 2.0
        let offsetY=(imgView!.bounds.size.height - imgView!.image!.size.height * scale) / 2.0
        let pixelRect=CGRectMake((x-offsetX)/scale, (y-offsetY)/scale, 30/scale, 30/scale)
        
        CGContextAddRect(ctx, pixelRect)
        UIColor.redColor().set()
        CGContextDrawPath(ctx, CGPathDrawingMode.Stroke)
        let imgNew = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        imgView?.image=imgNew
        
        dispatch_async(dispatch_get_global_queue(0, 0)) { 
            UIImageWriteToSavedPhotosAlbum(imgNew, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        
        let view1=UIView.init(frame: CGRectMake(10, 10, 20, 20))
        //元组
        let excatPoint=CGPointMake((x-offsetX)/scale, (y-offsetY)/scale)
        let tuple=self.getPixelColor(excatPoint, image: image)
        view1.backgroundColor=UIColor.init(red: tuple.red, green: tuple.green, blue: tuple.blue, alpha: tuple.alpha)
        //view1.backgroundColor=self.getPixelColorAtLocation(excatPoint)
        view.addSubview(view1)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>)  {
        self.alertNewAPI("提示", message: "图片保存成功", buttonTitles: ["确定","1","2","3","4"]) { (index) in
            print("图片保存完成")
        }
    }
    
    ///获取图片中某点的像素值,函数的返回值是一个元组
    func getPixelColor(pos:CGPoint, image:UIImage)->(alpha: CGFloat, red: CGFloat, green: CGFloat,blue:CGFloat){
        let pixelData=CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage))
        let data:UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let pixelInfo: Int = ((Int(image.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return (a,r,g,b)
    }

    private func getPixelColorAtLocation(point: CGPoint!) -> UIColor {
        let cgImage=image.CGImage!
        let context=self.createARGBBitmapContextFromImage(cgImage)
        
        let w  = CGImageGetWidth(cgImage)
        let h  = CGImageGetHeight(cgImage)
        
        let rect = CGRect(x:0, y:0, width:Int(w), height:Int(h))
        
        CGContextClearRect(context, rect)
        
        CGContextDrawImage(context, rect, cgImage)
        
        let data:UnsafeMutablePointer<Void> = CGBitmapContextGetData (context)
        let uintData=UnsafePointer<UInt8>(data)
        
        let offset = ((Int(w) * Int(point.y)) + Int(point.x)) * 4
        let alpha =  uintData[offset]
        let red = uintData[offset+1]
        let green = uintData[offset+2]
        let blue = uintData[offset+3]
        let color = UIColor.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha))
        free(data)
        return color
    }

    private func createARGBBitmapContextFromImage(inImage: CGImageRef) -> CGContext{
        
        var bitmapByteCount = 0
        var bitmapBytesPerRow = 0
        
        //Get image width, height
        let pixelsWide = CGImageGetWidth(inImage)
        let pixelsHigh = CGImageGetHeight(inImage)
        
        /*
         Declare the number of bytes per row. Each pixel in the bitmap in this
         this example is represented by 4 bytes; 8 bits each of red, green, blue, and alpha.
         
         ARGB和PARGB是针对32位图像而言的，Windows下图像可以是1位、4位、8位、16位、24位以及32位的。
         32位图像的一个像素 在内存中占4个字节，其排列顺序依次是Alpah,Red,Green,Blue,其中的Alpha表示该像素的透明程度
         */
        bitmapBytesPerRow = Int(pixelsWide) * 4
        bitmapByteCount = bitmapBytesPerRow * Int(pixelsHigh)
        
        // Use the generic RGB color space.
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // Allocate memory for image data. This is the destination in memory
        // where any drawing to the bitmap context will be rendered.
        let bitmapData = malloc(bitmapByteCount)
        
        // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
        // per component. Regardless of what the source image format is
        // (CMYK, Grayscale, and so on) it will be converted over to the format
        // specified here by CGBitmapContextCreate.
        let context = CGBitmapContextCreate(bitmapData, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, CGImageGetBitmapInfo(inImage).rawValue)
        
        return context!
    }
    
}

