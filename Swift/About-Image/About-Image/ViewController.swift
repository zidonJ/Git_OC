//
//  ViewController.swift
//  About-Image
//
//  Created by zidonj on 2017/3/22.
//  Copyright © 2017年 zidon. All rights reserved.
//

import UIKit
import ImageIO
import AssetsLibrary
import SnapKit
import CoreImage
import Accelerate

class ViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var temp: UILabel!
    let viewf:EdgeView = EdgeView.init(frame: CGRect.zero)
    let viewb:UIView = UIView()
    
    var berth = UIBezierPath()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let image:UIImage = UIImage.init(named: "1.jpg")!
        imgView.image = image

        
        view.layoutIfNeeded()

        
        viewf.image = image
        view.addSubview(viewf)
        viewf.snp.makeConstraints { (make) in
            make.leading.top.trailing.bottom.equalTo(imgView)
        }
    }

    @IBAction func slider(_ sender: UISlider) {
        
        //viewf.lineWidth = CGFloat(sender.value * 20)
        viewf.edgesConifg(width: CGFloat(sender.value * 20), type: .outside)
    }

    @IBAction func sliderContain(_ sender: UISlider) {
        viewf.edgesConifg(width: CGFloat(sender.value * 20), type: .inside)
    }
    
    
    @IBAction func save(_ sender: Any) {
        //viewf.save()
        
        
        let path = Bundle.main.path(forResource: "original1", ofType: "png")
        let image = UIImage.init(contentsOfFile: path!)
        let cgImage = image!.cgImage
        
        // create a source buffer
        var format = vImage_CGImageFormat(bitsPerComponent: 8, bitsPerPixel: 32, colorSpace: nil,
                                          bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
                                          version: 0, decode: nil, renderingIntent: CGColorRenderingIntent.defaultIntent)
        var sourceBuffer = vImage_Buffer()
        defer {
            sourceBuffer.data.deallocate(bytes: Int(sourceBuffer.height) * Int(sourceBuffer.height) * 4, alignedTo: 1)
        }
        
        var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, cgImage!, numericCast(kvImageNoFlags))
        guard error == kvImageNoError else { return }
        
        // create a destination buffer
        let scale = UIScreen.main.scale
        let destWidth = Int((image?.size.width)! * 0.01 )
        let destHeight = Int((image?.size.height)! * 0.01 )
        
        
        let bytesPerPixel = cgImage!.bitsPerPixel / 8
        let destBytesPerRow = destWidth * bytesPerPixel
        
        let destData = UnsafeMutablePointer<UInt8>.allocate(capacity: (destHeight * destBytesPerRow))
        defer {
            destData.deallocate(capacity: destHeight * destBytesPerRow)
        }
        var destBuffer = vImage_Buffer(data: destData, height: vImagePixelCount(destHeight), width: vImagePixelCount(destWidth), rowBytes: destBytesPerRow)
        
        // scale the image
        error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, numericCast(kvImageHighQualityResampling))
        guard error == kvImageNoError else { return  }
        
        // create a CGImage from vImage_Buffer
        let destCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, numericCast(kvImageNoFlags), &error)?.takeRetainedValue()
        guard error == kvImageNoError else { return  }
        
        // create a UIImage
        destCGImage.flatMap { (cgImg) in
            let img = UIImage.init(cgImage: cgImg)
            print(img);
        }
        //let scaledImage = destCGImage.flatMap { UIImage(CGImage: $0, scale: 0.0, orientation: image?.imageOrientation) }
    }
}

class EdgeView: UIView {
    
    public enum Frametype:Int {
        case outside
        case inside
    }
    
    var value:CGFloat = 0
    var imageView:UIImageView = UIImageView()
    var insideColor:UIColor?=nil
    var typeEdge:Frametype = Frametype.outside
    let topView:TopView = TopView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray
        
        self.addSubview(imageView)
        imageView.snp.makeConstraints({ (make) in
            make.leading.top.equalTo(self).offset(20)
            make.bottom.trailing.equalTo(self).offset(-20)
        })
        
        topView.backgroundColor = UIColor.clear
        self.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.edges.equalTo(imageView)
        }
        
        self.backgroundColor = UIColor.lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func save() {
        let width = (self.image?.size)?.width
        let height = (self.image?.size)?.height
        var imageTemp:UIImage
        UIGraphicsBeginImageContext((self.image?.size)!)
        
        let ctx:CGContext = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        let imageOrigin:CGFloat = value == 0 ? 0:20
        let rect:CGRect = CGRect.init(origin: CGPoint.init(x: imageOrigin, y: imageOrigin), size: CGSize.init(width: width!-2*imageOrigin, height: height!-2*imageOrigin))
        self.image?.draw(in: rect)
        let berth1:UIBezierPath = UIBezierPath.init(rect: CGRect.init(x: 20-value/2, y: 20-value/2, width: rect.size.width+value, height: rect.size.height+value))
        berth1.lineWidth = value
        UIColor.purple.setStroke()
        berth1.stroke()
        ctx.restoreGState()
        let berth2:UIBezierPath = UIBezierPath.init(rect: CGRect.init(x: 20+topView.value/2, y: 20+topView.value/2, width: rect.size.width-topView.value , height: rect.size.height-topView.value))
        berth2.lineWidth = topView.value
        UIColor.brown.setStroke()
        berth2.stroke()
        
        imageTemp = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(imageTemp, self, nil, nil)
    }
    
    
    
    var outColor:UIColor?=nil
    
    var image:UIImage? {
        
        set {
            imageView.image = newValue
        }
        
        get {
            return imageView.image
        }
    }
    
    func edgesConifg(width:CGFloat,type:Frametype) {
        value = width
        typeEdge = type
        
        if type == .inside {
            topView.value = value
        }else{
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let width:CGFloat = self.imageView.frame.size.width
        let height:CGFloat = self.imageView.frame.size.height
        let ctx:CGContext = UIGraphicsGetCurrentContext()!
        
        ctx.move(to: CGPoint.init(x: 20, y: 20))
        ctx.addRect(CGRect.init(origin: CGPoint.init(x: 20-value, y: 20-value), size: CGSize.init(width: width+value*2, height: height+value*2)))
        UIColor.purple.setFill()
        ctx.closePath()
        ctx.drawPath(using: .fill)
    }
}

class TopView: UIView {
    
    var saveValue:CGFloat = 0
    
    var value:CGFloat {
        get {
            return saveValue
        }

        set {
            saveValue = newValue
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let width:CGFloat = self.frame.size.width
        let height:CGFloat = self.frame.size.height
        let ctx:CGContext = UIGraphicsGetCurrentContext()!
        
        ctx.move(to: CGPoint.init(x: saveValue, y: saveValue))
        let rect:CGRect = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: width , height: height ))
        ctx.addRect(rect)
        UIColor.brown.setFill()
        ctx.closePath()
        ctx.drawPath(using: .fill)
        
        ctx.move(to: CGPoint.init(x: 20, y: 20))
        ctx.addRect(CGRect.init(origin: CGPoint.init(x: saveValue, y: saveValue), size: CGSize.init(width: width-2*saveValue, height: height-2*saveValue)))
        UIColor.clear.setFill()
        ctx.setBlendMode(.clear)
        ctx.closePath()
        ctx.drawPath(using: .fill)
    }
}

