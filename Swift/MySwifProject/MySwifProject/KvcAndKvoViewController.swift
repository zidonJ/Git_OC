//
//  KvcAndKvoViewController.swift
//  MySwifProject
//
//  Created by zidon on 15/5/7.
//  Copyright (c) 2015年 姜泽东. All rights reserved.
//

import UIKit

class KvcAndKvoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor=UIColor.groupTableViewBackground()
        _ = "hello world"
        let item=KvcItem()
        let dic:Dictionary<String,String>=["name":"Taylor Swift","age":"25","tall":"178","sex":"girl"]
        item.setValuesForKeys(dic)
        print("name:\(item.name)--age:\(item.age)--tall:\(item.tall)--sex:\(item.sex)--")
        
        lable.text=item.name
        lable.addObserver(self, forKeyPath: "text", options: NSKeyValueObservingOptions.new, context: nil)
        self.view.addSubview(lable)
        
        
        btn.setTitle("返回", for: UIControlState.disabled)
        btn.backgroundColor=UIColor.red()
        btn.addTarget(self, action: #selector(self.back), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btn)
        
        _=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(KvcAndKvoViewController.jojo), userInfo: nil, repeats: false)
    }
    
    let lable=UILabel(frame: CGRect(x:10,y:100, width:300, height:30))
    
    let btn=UIButton(frame: CGRect(x:10, y:150, width:100, height:30))
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: AnyObject?, change: [NSKeyValueChangeKey : AnyObject]?, context: UnsafeMutablePointer<Void>?) {
        print(change![NSKeyValueChangeKey.newKey])
        let str=change![NSKeyValueChangeKey.newKey] as? String
        print("swift的kvo监听:\(str)")
    }
    
    
    func back(){
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    //没有任何代码执行的时候,释放后会执行析构函数
    deinit{
        print("执行析构函数,移除Kvo监听")
        lable.removeObserver(self,forKeyPath:"text")
    }
    
    func jojo(){
        lable.text="Taylor Swift is my first love"
    }
}
