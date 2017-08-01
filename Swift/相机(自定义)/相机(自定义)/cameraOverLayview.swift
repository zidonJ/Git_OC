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
        self.backgroundColor=UIColor.red
        cancleButton.setTitle("取消", for: UIControlState())
        self.addSubview(cancleButton)
        cancleButton.snp.makeConstraints({ (make) in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.left.equalTo(self).offset(10)
            make.centerY.equalTo(self)
        })
        
        takePhoto.setTitle("拍照", for: UIControlState())
        takePhoto.addTarget(self, action: #selector(self.customTakeCapture), for: UIControlEvents.touchUpInside)
        addSubview(takePhoto)
        takePhoto.snp.makeConstraints({ (make) in
            make.width.equalTo(cancleButton.snp.width)
            make.height.equalTo(cancleButton.snp.height)
            make.center.equalTo(self)
        })

        usePhoto.setTitle("使用照片", for: UIControlState())
        addSubview(usePhoto)
        usePhoto.snp.makeConstraints({ (make) in
            make.width.equalTo(cancleButton.snp.width)
            make.height.equalTo(cancleButton.snp.height)
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(cancleButton)
        })
    }
    
    func customTakeCapture() {
        CustomCameraHelper.sharedInstance.captureStillImageWithBlock { (image) in
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)),nil)
        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
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

