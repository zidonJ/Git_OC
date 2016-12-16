//
//  ViewController.swift
//  iOS10SwiftCoreData
//
//  Created by zidonj on 2016/10/27.
//  Copyright © 2016年 zidon. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var page: UITextField!
    @IBOutlet weak var pheight: UITextField!
    @IBOutlet weak var pname: UITextField!
    @IBOutlet weak var ssex: UITextField!
    @IBOutlet weak var snum: UITextField!
    
    let dataRecord:ZDCoreDataStack=ZDCoreDataStack.init(dataName: "Person", storeType: NSSQLiteStoreType)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        print("测试stash 存储工作区 指针指向上一次提交")
        print("测试stash 存储工作区 指针指向上一次提交")

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func tappImageVies(_ sender: UITapGestureRecognizer) {
        print("storyboard 手势点击")
    }
    
    @IBAction func saveData(_ sender: UIButton) {
        //字典的值不可以为nil
        let img:UIImage=UIImage(named: "2.jpg")!
        
        let savePerson:Dictionary<String,Any>=["headImage":UIImageJPEGRepresentation(img, 0.5)!,
                                               "age":Int(page.text!)!,
                                               "height":Int(pheight.text!)!,
                                               "name":pname.text!,
                                               "weight":snum.text!]
        
        let person:Person=NSEntityDescription.insertNewObject(forEntityName: "Person", into: dataRecord.recordStack.context) as! Person
        if dataRecord.saveData(paramter: savePerson, enity: person) {
            print("数据存储成功")
        }
    }
    
}

