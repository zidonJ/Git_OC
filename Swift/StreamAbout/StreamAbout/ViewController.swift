//
//  ViewController.swift
//  StreamAbout
//
//  Created by 姜泽东 on 2018/5/3.
//  Copyright © 2018年 MaiTian. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,StreamDelegate{

    
    var readStream : InputStream?
    var file:FileReadAndWrite!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
         file = FileReadAndWrite()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let path = Bundle.main.path(forResource: "text", ofType: "txt")
        
        file.filePath = path
//        file.readFile(path: "") { (readString) in
//            print(readString)
//        }

        
        file.writeFile(path: "")
    }


}

