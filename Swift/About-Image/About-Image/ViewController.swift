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
        viewf.save()
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

