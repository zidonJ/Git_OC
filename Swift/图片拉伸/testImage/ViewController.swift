//
//  ViewController.swift
//  testImage
//
//  Created by zidonj on 2017/2/6.
//  Copyright © 2017年 zidon. All rights reserved.
//

import UIKit
import ObjectiveC

typealias VIMP = (_ id:Any,_ sel:Selector,_:String...)->Void

class ViewController: UIViewController {

    //创建信号量为1的信号,默认执行1次
    let signalSeam:DispatchSemaphore = DispatchSemaphore(value: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var image:UIImage = UIImage(named: "11")!
        
        // 设置端盖的值
        let top = 30
        let bottom = 10
        let left = 10
        let right = 10
        
//        objc_msgSend()
        
        let edgeInsets = UIEdgeInsetsMake(CGFloat(top), CGFloat(left), CGFloat(bottom), CGFloat(right))
        
        // 设置拉伸的模式
        let mode:UIImageResizingMode = UIImageResizingMode.stretch;
        
        image = image.resizableImage(withCapInsets: edgeInsets, resizingMode: mode)
        
        let imgView:UIImageView = UIImageView.init(image: image)
        imgView.backgroundColor=UIColor.green
        imgView.frame=CGRect.init(x: 30, y: 150, width: 300, height: 220)
        view.addSubview(imgView)
        
        
        imgView.layer.shadowPath=UIBezierPath.init(rect: imgView.bounds).cgPath
        imgView.layer.shadowColor=UIColor.red.cgColor
        imgView.layer.shadowOffset=CGSize.init(width: 12, height: 12)
        
        imgView.layer.shadowColor=UIColor.red.cgColor
        imgView.layer.shadowOffset=CGSize.init(width: 2, height: 2)
//        imgView.layer.shadowRadius=2
        imgView.layer.shadowOpacity=0.5
        
//        let imp:IMP = self.method(for: #selector(self.test(a:b:)))
//        let vimp:VIMP = unsafeBitCast(imp, to: VIMP.self)
//        vimp(self, #selector(self.test(a:b:)),"jojo1","jojo2")
//        
//        let sel:Selector = #selector(self.test(a:))
//        self.perform(sel, with: "jojo")
        
        
            
        self.test()
        
        
        let btn:TestButton=TestButton.init(type: .custom)
        
        btn.frame=CGRect.init(x: 10, y: 60, width: 50, height: 50);
        btn.setImage(UIImage.init(named: "11"), for: .normal)
        btn.setTitle("jojo", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.imageView?.backgroundColor=UIColor.red
        btn.titleLabel?.backgroundColor=UIColor.lightGray
        view.addSubview(btn)
    }
    
    func test() {
        
        for _ in 1...20 {
            let result:DispatchTimeoutResult = signalSeam.wait(timeout: DispatchTime.distantFuture)
            if result == DispatchTimeoutResult.success {
                print("信号量问题")
            }
            __dispatch_semaphore_signal(signalSeam)
        }
        
    }
    
    func test(a:String,b:String){
        print("jojo",a)
    }
    
    @IBAction func share(_ sender: UIButton) {
        
        let activityController:UIActivityViewController = UIActivityViewController.init(activityItems: ["test hello world"], applicationActivities: nil)
        
        self.present(activityController, animated: true) {
            
        }
        
    }

}

class TestButton: UIButton {
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        print(contentRect);
        return contentRect;
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        print(contentRect);
        return contentRect;
    }
}

