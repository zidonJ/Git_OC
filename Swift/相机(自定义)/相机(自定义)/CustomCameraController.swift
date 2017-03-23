//
//  CustomCameraController.swift
//  相机(自定义)
//
//  Created by zidon on 16/5/4.
//  Copyright © 2016年 zidon. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

class CustomCameraController: UIViewController {

    var cameraHelper:CustomCameraHelper?=nil
    var cameraControlView:cameraOverLayview?=nil
    let cameraView=UIView()
    var hpView:HelpView?=nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor=UIColor.white
        cameraControlView=cameraOverLayview()
        view.addSubview(cameraControlView!)
        
        cameraControlView?.snp.makeConstraints({ (make) in
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.bottom.equalTo(view).offset(0)
            make.height.equalTo(70)
        })
        
        cameraView.frame=CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height-75)
        view.addSubview(cameraView)
        
        cameraHelper=CustomCameraHelper.sharedInstance
        cameraHelper!.embedPreviewInView(cameraView)
        cameraHelper?.startRuning()
        
        
        hpView=HelpView.init(frame: cameraView.bounds)
        hpView!.backgroundColor=UIColor.clear
        view.addSubview(hpView!)
    }

}

class HelpView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let ctx=UIGraphicsGetCurrentContext()
        
        ctx?.addRect(CGRect(x: self.center.x-50, y: self.center.y-30, width: 100, height: 60))
        
        ctx?.setLineWidth(2)
        
        ctx?.setLineCap(.round)
        
        UIColor.green.set()
        
        ctx?.drawPath(using: .stroke)
    }
}
