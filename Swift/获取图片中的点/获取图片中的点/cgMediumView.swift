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
        self.backgroundColor=UIColor.whiteColor()
        let button=UIButton(type:UIButtonType.Custom)
        button.frame=CGRectMake(20, 20, 70, 30)
        button.setTitle("保存", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        button.backgroundColor=UIColor.whiteColor()
        button.addTarget(self, action: #selector(self.save), forControlEvents: UIControlEvents.TouchUpInside)
        addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        super.drawRect(rect)
        image=UIImage(named: "test.jpg")
        image.drawInRect(rect)
        
        for berTemp in pathArray{
            UIColor.redColor().set()
            let ber=berTemp as! UIBezierPath
            ber.lineWidth=3
            ber.lineCapStyle=CGLineCap.Round
            ber.stroke()
        }
        
    }
    
    func save(){
        UIGraphicsBeginImageContext(self.bounds.size)
        let ctx=UIGraphicsGetCurrentContext()
        self.layer.renderInContext(ctx!)
        let imageReDraw:UIImage=UIGraphicsGetImageFromCurrentImageContext()
        print(imageReDraw.size.width*imageReDraw.scale)
        UIGraphicsEndImageContext()
        dispatch_async(dispatch_get_global_queue(0, 0)) { 
            UIImageWriteToSavedPhotosAlbum(imageReDraw, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        if didFinishSavingWithError == nil {            
            self.alertNewAPI("图片保存", message: "图片保存成功", buttonTitles: ["取消","确定"], clickedIndex: { (index:Int) in
                print(index)
            })
        }
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch=touches.first
        let point=touch?.locationInView(self)
        berth.moveToPoint(point!)
        pathArray.append(berth)
        self.setNeedsDisplay()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for aTouch in touches{
            let location=aTouch.locationInView(self)
            let lastBerth=pathArray[pathArray.endIndex-1] as! UIBezierPath
            lastBerth.addLineToPoint(location)
            self.setNeedsDisplay()
        }
    }
}
