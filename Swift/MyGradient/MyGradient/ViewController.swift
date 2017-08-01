//
//  ViewController.swift
//  MyGradient
//
//  Created by zidonj on 2017/4/19.
//  Copyright © 2017年 zidon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let test:JGradientLabel = JGradientLabel.init(frame: CGRect.init(x: 10, y: 30, width: 300, height: 300))
        test.text = "txt"
        test.textColor = UIColor.red
        view.addSubview(test)
        
        self.gradientLabel();
        self.nbLabel()
    }
    
    func gradientLabel() {
        let label = UILabel.init(frame: CGRect.init(x: 100, y: 100, width: 200, height: 30))
        label.text = "这是一段经典的旋律"
        view.addSubview(label)
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = label.frame
        gradientLayer.colors = [self.randomColor(), self.randomColor(),self.randomColor()]
        view.layer.addSublayer(gradientLayer)
        // mask层工作原理:按照透明度裁剪，只保留非透明部分，文字就是非透明的，因此除了文字，其他都被裁剪掉，这样就只会显示文字下面渐变层的内容，相当于留了文字的区域，让渐变层去填充文字的颜色。
        gradientLayer.mask = label.layer;
        
        // 注意:一旦把label层设置为mask层，label层就不能显示了,会直接从父层中移除，然后作为渐变层的mask层，且label层的父层会指向渐变层，这样做的目的：以渐变层为坐标系，方便计算裁剪区域，如果以其他层为坐标系，还需要做点的转换，需要把别的坐标系上的点，转换成自己坐标系上点，判断当前点在不在裁剪范围内，比较麻烦。
        
        // 父层改了，坐标系也就改了，需要重新设置label的位置，才能正确的设置裁剪区域。
        label.frame = gradientLayer.bounds;
    }
    
    func nbLabel()  {
        let size = CGSize(width: 256, height: 256)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()!

        context.translateBy (x: size.width / 2, y: size.height / 2)
        context.scaleBy (x: 1, y: -1)
        
        centreArcPerpendicular(text: "Hello round world", context: context, radius: 100, angle: 0, colour: UIColor.red, font: UIFont.systemFont(ofSize: 16), clockwise: true)
        centreArcPerpendicular(text: "Anticlockwise", context: context, radius: 100, angle: CGFloat(-Double.pi/2), colour: UIColor.red, font: UIFont.systemFont(ofSize: 16), clockwise: false)
        centre(text: "Hello flat world", context: context, radius: 0, angle: 0 , colour: UIColor.red, font: UIFont.systemFont(ofSize: 16), slantAngle: CGFloat(Double.pi/4))
        
        let _ = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    func centreArcPerpendicular(text str: String, context: CGContext, radius r: CGFloat, angle theta: CGFloat, colour c: UIColor, font: UIFont, clockwise: Bool){
        
        let l = str.characters.count
        let attributes = [NSFontAttributeName: font]
        
        let characters: [String] = str.characters.map { String($0) } // An array of single character strings, each character in str
        var arcs: [CGFloat] = [] // This will be the arcs subtended by each character
        var totalArc: CGFloat = 0 // ... and the total arc subtended by the string
        
        // Calculate the arc subtended by each letter and their total
        for i in 0 ..< l {
            arcs += [chordToArc(characters[i].size(attributes: attributes).width, radius: r)]
            totalArc += arcs[i]
        }
        
        // Are we writing clockwise (right way up at 12 o'clock, upside down at 6 o'clock)
        // or anti-clockwise (right way up at 6 o'clock)?
        let direction: CGFloat = clockwise ? -1 : 1
        let slantCorrection = clockwise ? -CGFloat(Double.pi/2) : CGFloat(Double.pi/2)
        
        // The centre of the first character will then be at
        // thetaI = theta - totalArc / 2 + arcs[0] / 2
        // But we add the last term inside the loop
        var thetaI = theta - direction * totalArc / 2
        
        for i in 0 ..< l {
            thetaI += direction * arcs[i] / 2
            // Call centerText with each character in turn.
            // Remember to add +/-90º to the slantAngle otherwise
            // the characters will "stack" round the arc rather than "text flow"
            centre(text: characters[i], context: context, radius: r, angle: thetaI, colour: c, font: font, slantAngle: thetaI + slantCorrection)
            // The centre of the next character will then be at
            // thetaI = thetaI + arcs[i] / 2 + arcs[i + 1] / 2
            // but again we leave the last term to the start of the next loop...
            thetaI += direction * arcs[i] / 2
        }
    }
    
    func chordToArc(_ chord: CGFloat, radius: CGFloat) -> CGFloat {
        return 2 * asin(chord / (2 * radius))
    }
    
    func centre(text str: String, context: CGContext, radius r:CGFloat, angle theta: CGFloat, colour c: UIColor, font: UIFont, slantAngle: CGFloat) {
        // *******************************************************
        // This draws the String str centred at the position
        // specified by the polar coordinates (r, theta)
        // i.e. the x= r * cos(theta) y= r * sin(theta)
        // and rotated by the angle slantAngle
        // *******************************************************
        
        // Set the text attributes
        let attributes = [NSForegroundColorAttributeName: c,
                          NSFontAttributeName: font]
        // Save the context
        context.saveGState()
        // Undo the inversion of the Y-axis (or the text goes backwards!)
        context.scaleBy(x: 1, y: -1)
        // Move the origin to the centre of the text (negating the y-axis manually)
        context.translateBy(x: r * cos(theta), y: -(r * sin(theta)))
        // Rotate the coordinate system
        context.rotate(by: -slantAngle)
        // Calculate the width of the text
        let offset = str.size(attributes: attributes)
        // Move the origin by half the size of the text
        context.translateBy (x: -offset.width / 2, y: -offset.height / 2) // Move the origin to the centre of the text (negating the y-axis manually)
        // Draw the text
        str.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
        // Restore the context
        context.restoreGState()
    }

    func randomColor() -> CGColor {
        let r:CGFloat = CGFloat(arc4random_uniform(256))/CGFloat(255)
        let g:CGFloat = CGFloat(arc4random_uniform(256))/CGFloat(255)
        let b:CGFloat = CGFloat(arc4random_uniform(256))/CGFloat(255)
        return UIColor.init(red: r, green: g, blue: b, alpha: 1).cgColor
    }


}
