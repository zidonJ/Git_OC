//
//  cameraOverLayview.swift
//  相机(自定义)
//
//  Created by zidon on 16/4/26.
//  Copyright © 2016年 zidon. All rights reserved.
//

import UIKit
import SnapKit

class cameraOverLayview: UIView {

    let cancleButton=UIButton()
    let takePhoto=UIButton()
    let usePhoto=UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor.redColor()
        cancleButton.setTitle("取消", forState: UIControlState.Normal)
        self.addSubview(cancleButton)
        cancleButton.snp_makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.left.equalTo(self).offset(10)
            make.centerY.equalTo(self)
        }
        
        takePhoto.setTitle("拍照", forState: UIControlState.Normal)
        takePhoto.addTarget(self, action: #selector(self.customTakeCapture), forControlEvents: UIControlEvents.TouchUpInside)
        addSubview(takePhoto)
        takePhoto.snp_makeConstraints { (make) in
            make.width.equalTo(cancleButton.snp_width)
            make.height.equalTo(cancleButton.snp_height)
            make.center.equalTo(self)
        }

        usePhoto.setTitle("使用照片", forState: UIControlState.Normal)
        addSubview(usePhoto)
        usePhoto.snp_makeConstraints { (make) in
            make.width.equalTo(cancleButton.snp_width)
            make.height.equalTo(cancleButton.snp_height)
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(cancleButton)
        }
    }
    
    func customTakeCapture() {
        CustomCameraHelper.sharedInstance.captureStillImageWithBlock { (image) in
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)),nil)
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error != nil {
            self.alertNewAPI("错误", message: "保存图片失败", buttonTitles: ["确定"], clickedIndex: { (inde) in
                
            })
        } else {
            self.alertNewAPI("成功", message: "保存图片成功", buttonTitles: ["确定"], clickedIndex: { (inde) in
                print("点击消失")
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

