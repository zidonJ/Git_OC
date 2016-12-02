//
//  ViewController.swift
//  SwiftUIControl
//
//  Created by zidon on 15/5/6.
//  Copyright (c) 2015年 zidon. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate,myDelegate
{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //代码cell
        //self.myFirstTableView!.registerClass(SwiftTableViewCell.self, forCellReuseIdentifier: "cell")
        //xib的cell
        let nib=UINib(nibName: "SwiftTableViewCell", bundle: nil)
        self.myFirstTableView!.register(nib, forCellReuseIdentifier: "cell")
//----------------------------------------------------------------------------------
        class People : NSObject
        {
            //普通属性
            var firstName:String = ""
            var lastName:String  = ""
            var nickName:String  = ""
            //计算属性
            var fullName:String{
                get{
                    return nickName + " " + firstName + " " + lastName
                }
            }
            //带属性监视器的普通属性
            var age:Int = 0{
                //我们需要在age属性变化前做点什么
                willSet{
                    print("Will set an new value \(newValue) to age")
                }
                //我们需要在age属性发生变化后，更新一下nickName这个属性
                didSet{
                    print("age filed changed form \(oldValue) to \(age)")
                    if age<10{
                        nickName = "Little"
                    }else{
                        nickName = "Big"
                    }
                }
            }
            
            func toString() -> String{
                return "Full Name: \(fullName) " + ", Age: \(age) "
            }
            
        }
        let test = People()
        test.firstName = "Zhang"
        test.lastName  = "San"
        test.age = 20
        
        let con=config()
        if con.IS_IOS8{
            print("这是iOS8系统")
        }
    }

    @IBOutlet weak var myFirstTableView: UITableView!
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! SwiftTableViewCell
        //cell.cellContent.text=String(format: "%d", indexPath.row)
        cell.textContent=String(format: "%d", indexPath.row)
        cell.swiftDelegate=self
        cell.swiftBlock={
            a in
            print("block传值:\(a)")
            return "block返回值:\(a)__哈哈"
        }
        return cell
    }
    func swiftDelegateSendObjc(a:AnyObject){
        print("代理传值:\(a)")
    }
}

