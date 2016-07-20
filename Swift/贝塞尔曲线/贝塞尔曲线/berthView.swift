//
//  berthView.swift
//  贝塞尔曲线
//
//  Created by zidon on 16/4/6.
//  Copyright © 2016年 zidon. All rights reserved.
//

import UIKit

class berthView: UIView {
    
    var berth:UIBezierPath?=nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        berth=UIBezierPath.init(roundedRect: self.bounds, cornerRadius: 15)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        let context=UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        CGContextSetLineWidth(context, 5)
        CGContextAddPath(context, berth!.CGPath)
        CGContextDrawPath(context, CGPathDrawingMode.Stroke)
        
        let str:String="这是一段经典的旋律"
        
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByCharWrapping
        paragraphStyle.alignment = NSTextAlignment.Center
        
        str.drawInRect(self.bounds, withAttributes: [NSFontAttributeName:UIFont.systemFontOfSize(20),NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:UIColor.greenColor()])
        
    }
}
