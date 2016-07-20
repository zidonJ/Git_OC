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
        
        view.backgroundColor=UIColor.whiteColor()
        cameraControlView=cameraOverLayview()
        view.addSubview(cameraControlView!)
        
        cameraControlView!.snp_makeConstraints { (make) in
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.bottom.equalTo(view).offset(0)
            make.height.equalTo(70)
        }
        
        cameraView.frame=CGRectMake(0, 0, view.frame.size.width, view.frame.size.height-75)
        view.addSubview(cameraView)
        
        cameraHelper=CustomCameraHelper.sharedInstance
        cameraHelper!.embedPreviewInView(cameraView)
        cameraHelper?.startRuning()
        
        
        hpView=HelpView.init(frame: cameraView.bounds)
        hpView!.backgroundColor=UIColor.clearColor()
        view.addSubview(hpView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class HelpView: UIView {
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let ctx=UIGraphicsGetCurrentContext()
        
        CGContextAddRect(ctx, CGRectMake(self.center.x-50, self.center.y-30, 100, 60))
        
        CGContextSetLineWidth(ctx, 2)
        
        CGContextSetLineCap(ctx, .Round)
        
        UIColor.greenColor().set()
        
        CGContextDrawPath(ctx, .Stroke)
    }
}
