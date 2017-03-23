//
//  CustomCameraHelper.swift
//  相机(自定义)
//
//  Created by zidon on 16/5/5.
//  Copyright © 2016年 zidon. All rights reserved.
//

import UIKit
import AVFoundation

typealias CaptureImageBlock=(UIImage)->()

class CustomCameraHelper: NSObject {
    
    //采用闭包懒加载属性
    lazy var session:AVCaptureSession={
        let session=AVCaptureSession()
        session.canSetSessionPreset(AVCaptureSessionPreset352x288)
        return session
    }()
    
    lazy var videoInput:AVCaptureDeviceInput={
        let videoInput=try! AVCaptureDeviceInput.init(device: self.backFacingCamera())
        return videoInput
    }()
    
    lazy var videoCaptureLayer:AVCaptureVideoPreviewLayer={
        let captureLayer=AVCaptureVideoPreviewLayer.init(session: self.session)
        return captureLayer! as AVCaptureVideoPreviewLayer
    }()
    
    
    let captureStillImageOutput=AVCaptureStillImageOutput()
    //形成单利
    static let sharedInstance = CustomCameraHelper()
    
    override init() {
        super.init()
        let outPutSettings=[AVVideoCodecJPEG:AVVideoCodecKey]
        captureStillImageOutput.outputSettings=outPutSettings
        if session.canAddInput(videoInput) {
            session.addInput(videoInput)
        }
        session.addOutput(captureStillImageOutput)
    }
    
    ///照相机界面加在哪里
    func embedPreviewInView(_ cameraView:UIView) {
        
        videoCaptureLayer.frame=cameraView.bounds
        videoCaptureLayer.videoGravity=AVLayerVideoGravityResizeAspectFill
        cameraView.layer.addSublayer(videoCaptureLayer)
    }
    
    func captureStillImageWithBlock(_ captureClosure:@escaping CaptureImageBlock) {
        var videoConnection:AVCaptureConnection?=nil
        for connection in captureStillImageOutput.connections{
            for capturePort in (connection as AnyObject).inputPorts{
                if (capturePort as AnyObject).mediaType==AVMediaTypeVideo {
                    videoConnection=connection as? AVCaptureConnection
                    break
                }
            }
            if (videoConnection != nil) {break}
        }
        captureStillImageOutput.captureStillImageAsynchronously(from: videoConnection) { (imageSampleBuffer, error) in
            let data:Data=AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageSampleBuffer)
            print("开始生成图片")
            let image:UIImage=UIImage.init(data: data)!
            captureClosure(image)
        }
    }
    ///开始取景
    func startRuning() {
        session.startRunning()
    }
    ///结束取景
    func stopRunning() {
        session.stopRunning()
    }
    ///切换镜头
    func toggleCamera() {
        self.toggleCamera()
    }
    
    func toggleCameraPosition() -> Bool {
        var success=false
        if self.cameraCount()>1 {
            var newVideoInput:AVCaptureDeviceInput?=nil
            let position:AVCaptureDevicePosition=videoInput.device.position
            switch position {
                case AVCaptureDevicePosition.back:
                    newVideoInput=try! AVCaptureDeviceInput.init(device: self.frontFacingCamera())
                    break
                case AVCaptureDevicePosition.front:
                    newVideoInput=try! AVCaptureDeviceInput.init(device: self.backFacingCamera())
                    break
                case AVCaptureDevicePosition.unspecified:
                    
                    break
            }
            if newVideoInput != nil {
                session.beginConfiguration()
                session.removeInput(videoInput)
                if session.canAddInput(newVideoInput) {
                    session.addInput(newVideoInput)
                }else{
                    session.addInput(videoInput)
                }
                session.commitConfiguration()
                success=true
            }
            
        }
        return success
    }

    
    fileprivate func cameraWithPosition(_ position:AVCaptureDevicePosition) ->  AVCaptureDevice!{
        let devices=AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        for device in devices!{
            if (device as? AVCaptureDevice)!.position==position {
                return device  as? AVCaptureDevice
            }
        }
        return nil
    }
    
    func backFacingCamera() ->AVCaptureDevice{
        return self.cameraWithPosition(AVCaptureDevicePosition.back)
    }
    
    func frontFacingCamera() ->AVCaptureDevice{
        return self.cameraWithPosition(AVCaptureDevicePosition.front)
    }
    
    func cameraCount() -> Int {
        return AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo).count
    }
}
