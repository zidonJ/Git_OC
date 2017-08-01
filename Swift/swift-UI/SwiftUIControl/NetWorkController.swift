//
//  NetWorkController.swift
//  SwiftUIControl
//
//  Created by zidonj on 2017/1/17.
//  Copyright © 2017年 zidon. All rights reserved.
//

import UIKit
import Alamofire

class NetWorkController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //let model:NBModel = NBModel.init(map: <#T##Map#>)
     
        Alamofire.request("").responseJSON { (response) in
            
        }
        
    }

    
}
