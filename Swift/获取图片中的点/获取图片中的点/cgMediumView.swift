//
//  cgMediumView.swift
//  获取图片中的点
//
//  Created by zidon on 16/4/28.
//  Copyright © 2016年 zidon. All rights reserved.
//

import UIKit

class cgMediumView: UIView {
    
    var pathArray:Array<Any>=[]
    let berth=UIBezierPath()
    var image:UIImage!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor.white
        let button=UIButton(type:UIButtonType.custom)
        button.frame=CGRect(x:20, y:20, width:70, height:30)
        button.setTitle("保存", for: UIControlState.normal)
        button.setTitleColor(UIColor.red, for: UIControlState.normal)
        button.backgroundColor=UIColor.white
        button.addTarget(self, action: #selector(self.save), for: UIControlEvents.touchUpInside)
        addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        image=UIImage(named: "test.jpg")
        image.draw(in: rect)
        
        for berTemp in pathArray{
            UIColor.red.set()
            let ber=berTemp as! UIBezierPath
            ber.lineWidth=3
            ber.lineCapStyle=CGLineCap.round
            ber.stroke()
        }
        
    }
    
    func save(){
        UIGraphicsBeginImageContext(self.bounds.size)
        let ctx=UIGraphicsGetCurrentContext()
        self.layer.render(in: ctx!)
        let imageReDraw:UIImage=UIGraphicsGetImageFromCurrentImageContext()!
        print(imageReDraw.size.width*imageReDraw.scale)
        UIGraphicsEndImageContext()
        DispatchQueue.global().async {
            UIImageWriteToSavedPhotosAlbum(imageReDraw, self, #selector(cgMediumView.image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
        
    }
    
    func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        if didFinishSavingWithError == nil {            
            self.alertNewAPI(title: "图片保存", message: "图片保存成功", buttonTitles: ["取消","确定"], clickedIndex: { (index:Int) in
                print(index)
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch=touches.first
        let point=touch?.location(in: self)
        berth.move(to: point!)
        pathArray.append(berth)
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for aTouch in touches{
            let location=aTouch.location(in: self)
            let lastBerth=pathArray[pathArray.endIndex-1] as! UIBezierPath
            lastBerth.addLine(to: location)
            self.setNeedsDisplay()
        }
    }

}
