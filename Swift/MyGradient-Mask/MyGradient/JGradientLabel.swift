//
//  JGradientLabel.swift
//  MyGradient
//
//  Created by zidonj on 2017/4/19.
//  Copyright © 2017年 zidon. All rights reserved.
//

import UIKit

class JGradientLabel: UILabel {
    
    fileprivate var colors:Array<UIColor> = [UIColor]()
    
    override func draw(_ rect: CGRect) {
//        let ctx = UIGraphicsGetCurrentContext()
        self.textColor.set()
        let style:NSMutableParagraphStyle = NSMutableParagraphStyle()
        style.alignment = .center
        style.lineBreakMode = .byCharWrapping
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.red,
                          NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),
                          NSAttributedStringKey.paragraphStyle:style]
        
        self.text?.draw(at: CGPoint.zero, withAttributes: attributes)
    }
    
    func set(gradientColors:Array<UIColor>) {
        colors = gradientColors
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
