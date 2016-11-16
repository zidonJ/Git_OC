//
//  ViewController.swift
//  获取图片中的点
//
//  Created by zidon on 16/4/27.
//  Copyright © 2016年 zidon. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,mediumViewDelegate{
    
    var imgView:UIImageView!
    let image=UIImage.init(named: "1.jpg")!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imgView=UIImageView.init(frame: view.bounds)
        imgView!.image=image
        imgView?.contentMode=UIViewContentMode.scaleAspectFit
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
        
        UIGraphicsBeginImageContext(imgView.image!.size)
        let ctx=UIGraphicsGetCurrentContext()
        
        imgView.image!.draw(in: CGRect.init(x: 0, y: 0, width: (imgView?.image?.size.width)!, height: (imgView?.image?.size.height)!))
        ctx!.setLineWidth(3)
        
        //视图坐标到图片距离的转换（只适用于ScaleAspectFit的存在）
        
        let scale=min(imgView!.bounds.size.width / imgView!.image!.size.width,
            imgView!.bounds.size.height / imgView!.image!.size.height)
        
        let offsetX=(imgView!.bounds.size.width - imgView!.image!.size.width * scale) / 2.0
        let offsetY=(imgView!.bounds.size.height - imgView!.image!.size.height * scale) / 2.0
        
        let pixelRect=CGRect(x:(x-offsetX)/scale, y:(y-offsetY)/scale, width:30/scale, height:30/scale)
        
        ctx!.addRect(pixelRect)
        UIColor.red.set()
        ctx!.drawPath(using: CGPathDrawingMode.stroke)
        let imgNew = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        imgView?.image=imgNew
        
        DispatchQueue.global().async {
            [weak self] in
            UIImageWriteToSavedPhotosAlbum(imgNew!, self, #selector(ViewController.saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
        }
        
        let view1=UIView.init(frame: CGRect(x:10, y:10, width:20, height:20))
        //元组
        let excatPoint=CGPoint(x:(x-offsetX)/scale, y:(y-offsetY)/scale)
        let tuple=self.getPixelColor(pos: excatPoint, image: image)
        view1.backgroundColor=UIColor(red: tuple.red, green: tuple.green, blue: tuple.blue, alpha: tuple.alpha)
        //view1.backgroundColor=self.getPixelColorAtLocation(excatPoint)
        view.addSubview(view1)
    }
    
    func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer)  {
        self.alertNewAPI(title: "提示", message: "图片保存成功", buttonTitles: ["确定","1","2","3","4"]) { (index) in
            print("图片保存完成")
        }
    }
    
    ///获取图片中某点的像素值,函数的返回值是一个元组
    func getPixelColor(pos:CGPoint, image:UIImage)->(alpha: CGFloat, red: CGFloat, green: CGFloat,blue:CGFloat){
        let pixelData=image.cgImage!.dataProvider!.data
        let data:UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let pixelInfo: Int = ((Int(image.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return (a,r,g,b)
    }
}

