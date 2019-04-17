//
//  ViewController.swift
//  SwiftEventCapture
//
//  Created by zidon on 16/8/17.
//  Copyright © 2016年 zidon. All rights reserved.
//

import UIKit

class ViewController: UIViewController , RunloopEventCaptureDelegate ,UITableViewDelegate,UITableViewDataSource{

    var eventCapture:RunloopEventCapture=RunloopEventCapture.sharedInstace
    var dataSource:Array=[AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        let btn:UIButton=UIButton.init(type: UIButtonType.custom)
        btn.tag=100
        btn.frame=CGRect(x: 10, y: 60, width: 100, height: 30)
        btn.backgroundColor=UIColor.red
        btn.setTitle("测试哈", for: UIControlState.normal)
        btn.addTarget(self, action: #selector(ViewController.testRunloopCapture(btn:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btn)
        
        let btn0:UIButton=UIButton.init(type: UIButtonType.custom)
        btn0.frame=CGRect(x: 10, y: 100, width: 100, height: 30)
        btn0.tag=0
        btn0.backgroundColor=UIColor.red
        btn0.setTitle("0", for: UIControlState.normal)
        btn0.addTarget(self, action: #selector(ViewController.testRunloopCapture(btn:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btn0)
        
        
        let btn1:UIButton=UIButton.init(type: UIButtonType.custom)
        btn1.frame=CGRect(x: 10, y: 140, width: 100, height: 30)
        btn1.tag=1
        btn1.backgroundColor=UIColor.red
        btn1.setTitle("1", for: UIControlState.normal)
        btn1.addTarget(self, action: #selector(self.testRunloopCapture(btn:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btn1)
        
        let btn2:UIButton=UIButton.init(type: UIButtonType.custom)
        btn2.frame=CGRect(x: 10, y: 200, width: 100, height: 30)
        btn2.tag=2
        btn2.backgroundColor=UIColor.red
        btn2.setTitle("2", for: UIControlState.normal)
        btn2.addTarget(self, action: #selector(self.testRunloopCapture(btn:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btn2)
        
        let btn3:UIButton=UIButton.init(type: UIButtonType.custom)
        btn3.frame=CGRect(x: 10, y: 240, width: 100, height: 30)
        btn3.tag=3
        btn3.backgroundColor=UIColor.red
        btn3.setTitle("3", for: UIControlState.normal)
        btn3.addTarget(self, action: #selector(self.testRunloopCapture(btn:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btn3)
        
        eventCapture.delegate=self
        
        //添加字符串
//        eventCapture.addKeysTask(["那一种寸步不离的感觉，我知道就叫做永远","1","2","3","4"])
        
        let dic1:Dictionary<String,String>=["eventId":"100","userId":"200","timereavl":"300","clickCount":"400"]
        let dic2:Dictionary<String,String>=["eventId":"101","userId":"201","timereavl":"301","clickCount":"401"]
        let dic3:Dictionary<String,String>=["eventId":"102","userId":"202","timereavl":"302","clickCount":"402"]
        let dic4:Dictionary<String,String>=["eventId":"103","userId":"203","timereavl":"303","clickCount":"403"]
        let dic5:Dictionary<String,String>=["eventId":"104","userId":"204","timereavl":NSDate.getTimestamp(),"clickCount":"404"]
        
        let arrayCapture:Array=[dic1,dic2,dic3,dic4,dic5]
        
        
        for dic in arrayCapture{
            let item:CaptureItem=CaptureItem()
            item.setValuesForKeys(dic)
            dataSource.append(item)
        }
        //添加模型
        eventCapture.addItemsTask(items: dataSource as NSArray)
    }
    
    func asyncUploadCaptureUserData(data: AnyObject) -> Bool {
        let item:CaptureItem=data as! CaptureItem
        print("上传的用户数据",":",data,"->:",item.timereavl ?? "没有",item.eventId ?? "",#line)
        return true
    }
    
    func testRunloopCapture(btn:UIButton) {
        
        switch btn.tag {
        case 0:
            eventCapture.addTask(key: dataSource[0])
        case 1:
            eventCapture.addTask(key: dataSource[1])
        case 2:
            eventCapture.addTask(key: dataSource[2])
        case 3:
            eventCapture.addTask(key: dataSource[3])
        default:
            eventCapture.addTask(key: dataSource[4])
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId="cell"
        var cell:UITableViewCell?=tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell=UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
        }
        return cell!
    }
}

