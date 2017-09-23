//
//  ViewController.swift
//  RealmUse
//
//  Created by 姜泽东 on 2017/9/15.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    
    @IBOutlet weak var p_stuName: UITextField!
    @IBOutlet weak var sex: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var classname: UITextField!
    @IBOutlet weak var c_stuname: UITextField!
    
    
    
    lazy var realm: Realm = {
        
        var fileUrl:URL = URL(string: NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last!)!
        fileUrl.appendPathComponent("rlm.realm")
        //print(fileUrl)
        let realm = try! Realm(fileURL: fileUrl)
        return realm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }

    @IBAction func saveStudent(_ sender: UIButton) {
        
        let stu = Person()
        stu.studentName = p_stuName.text!
        stu.sex = sex.text!
        stu.height = Int(height.text!)!
        
        try! realm.write {
            realm.add(stu)
        }
        
//        DispatchQueue(label: "background").async {
//            autoreleasepool {
//                try! self.realm.write {
//                    self.realm.add(stu)
//                }
//            }
//        }
    }
    
    @IBAction func saveClass(_ sender: UIButton) {
        
        
        let cls = SCClass()
        cls.scclassName = classname.text!
        cls.studentName = c_stuname.text!
        
        try! realm.write {
            realm.add(cls)
        }
    }
    
    @IBAction func deleteData(_ sender: UIButton) {
    }

    @IBAction func selectData(_ sender: UIButton) {
    }
}

