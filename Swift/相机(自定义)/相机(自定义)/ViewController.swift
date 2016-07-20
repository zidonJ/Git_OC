//
//  ViewController.swift
//  相机(自定义)
//
//  Created by zidon on 16/4/22.
//  Copyright © 2016年 zidon. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    let imagePicker=UIImagePickerController()
    
    let cameraController=CustomCameraController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate=self
        
//        self.alertNewAPI("123", message: "123456", buttonTitles: ["确定"]) { (index) in
//            print("测试")
//        }
        
    }
    
    @IBAction func customCamera(sender: UIButton) {
        self.presentViewController(cameraController, animated: true) { 
            print("自定义相机")
        }
    }
    
    @IBAction func systemOfferCamera(sender: UIButton) {
        imagePicker.sourceType=UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true) {
            print("跳转到系统相机了")
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true) {
            print("拍完照了")
        }
        let image=info["UIImagePickerControllerOriginalImage"]
        if picker.sourceType == UIImagePickerControllerSourceType.Camera{
            dispatch_sync(dispatch_get_global_queue(0, 0), {
                UIImageWriteToSavedPhotosAlbum(image! as! UIImage, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)),nil)
            })
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if let err = error {
            UIAlertView(title: "错误", message: err.localizedDescription, delegate: nil, cancelButtonTitle: "确定").show()
            
        } else {
            UIAlertView(title: "提示", message: "保存成功", delegate: nil, cancelButtonTitle: "确定").show()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


