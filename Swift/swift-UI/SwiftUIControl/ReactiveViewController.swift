//
//  ReactiveViewController.swift
//  SwiftUIControl
//
//  Created by zidonj on 2017/1/17.
//  Copyright © 2017年 zidon. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class ReactiveViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let count:Signal = name.reactive.textValues.map{
            return $0?.characters.count
        }
        
        print(count)
        
        name.reactive.continuousTextValues.observeValues { value in
            print("Value: \(value)")
        }
        
        //map用于转换信号量属性  text->Int
        var newSignal = name.reactive.continuousTextValues.map { (value) -> Int in
            return (value! as String).characters.count
        }
        
        //对信号量属性进行过滤
        newSignal = newSignal.filter { (value) -> Bool in
            return value>5
        }
        
        //绑定一个text类型的信号
        testLabel.reactive.text <~ name.reactive.continuousTextValues
        
        //监听信号量的属性 之前已经map过从text->Int
        newSignal.observeValues { (value) in
            print("他妈的,OK")
        }
        
    }

}
