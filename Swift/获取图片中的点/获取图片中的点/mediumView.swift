//
//  mediumView.swift
//  获取图片中的点
//
//  Created by zidon on 16/4/27.
//  Copyright © 2016年 zidon. All rights reserved.
//

import UIKit

protocol mediumViewDelegate {
    func touchPoint(point:CGPoint!)
}

class mediumView: UIView {

    var delegate:mediumViewDelegate?
    
    init(testPara:Int, frame:CGRect){
        super.init(frame: frame)
        self.backgroundColor=UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let point = touch?.locationInView(self)
        delegate?.touchPoint(point)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }

}
