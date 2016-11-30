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
    @IBOutlet weak var ssex: UITextField!
    @IBOutlet weak var snum: UITextField!
    
    let dataRecord:ZDCoreDataStack=ZDCoreDataStack.init(dataName: "swift 3.0 ios 10", storeType: NSSQLiteStoreType)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func tappImageVies(_ sender: UITapGestureRecognizer) {
        print("storyboard 手势点击")
    }
    
    @IBAction func saveData(_ sender: UIButton) {
        
        let savePerson:Dictionary<String,AnyObject>=["headImage":imageView.image!,"age":page.text as AnyObject,"height":pheight.text! as AnyObject]
        if dataRecord.saveData(paramter: savePerson)==true{
            
        }
        
    }
    
}

