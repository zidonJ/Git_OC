//
//  AutoLayoutController.swift
//  SwiftUIControl
//
//  Created by zidonj on 2017/1/17.
//  Copyright © 2017年 zidon. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import SnapKit

class AutoLayoutController: UIViewController {

    let name:UILabel = UILabel()
    let password:UILabel = UILabel()
    let nameField:UITextField = UITextField()
    let pwdField:UITextField = UITextField()
    let loginBtn:UIButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.groupTableViewBackground
        
        name.text = "name:"
        name.textAlignment = NSTextAlignment.right
        view.addSubview(name)
        name.snp.makeConstraints { (make) in
            make.top.equalTo(80)
            make.left.equalTo(20)
            make.width.equalTo(70)
            make.height.equalTo(20)
        }
        
        password.text = "password:"
        password.textAlignment = NSTextAlignment.right
        view.addSubview(password)
        password.snp.makeConstraints { (make) in
            make.top.equalTo(name.snp.bottom).offset(20)
            make.right.equalTo(name)
            make.height.equalTo(name)
            make.width.greaterThanOrEqualTo(80)
        }
        
        nameField.borderStyle = .roundedRect
        nameField.backgroundColor = UIColor.yellow
        
        let nameEnble:Signal = nameField.reactive.continuousTextValues.map { (value) -> Int in
            return (value! as String).characters.count
        }.filter { (value) -> Bool in
            return value > 5
        }
        
        view.addSubview(nameField)
        nameField.snp.makeConstraints { (make) in
            make.left.equalTo(name.snp.right).offset(10)
            make.centerY.equalTo(name)
            make.right.equalTo(-20)
        }
        
        pwdField.borderStyle = .roundedRect
        pwdField.backgroundColor = UIColor.yellow
        
        let pwdEnble:Signal = pwdField.reactive.continuousTextValues.map { (value) -> Int in
            return (value! as String).characters.count
        }.filter { (value) -> Bool in
            return value > 5
        }
        
        view.addSubview(pwdField)
        pwdField.snp.makeConstraints { (make) in
            make.left.equalTo(password.snp.right).offset(10)
            make.centerY.equalTo(password)
            make.right.equalTo(-20)
        }
        
        loginBtn.backgroundColor = UIColor.lightGray
        loginBtn.setTitleColor(UIColor.blue, for: .normal)
        loginBtn.setTitle("Login", for: .normal)
        loginBtn.layer.cornerRadius = 5
        loginBtn.isEnabled = false
        loginBtn.clipsToBounds = true
        view.addSubview(loginBtn)
        
        nameEnble.observeValues { (value) in
            self.nameField.backgroundColor = UIColor.white
        }
        pwdEnble.observeValues { (value) in
            self.loginBtn.isEnabled = true
            self.pwdField.backgroundColor = UIColor.white
        }
        
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(pwdField.snp.bottom).offset(30)
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.centerX.equalTo(self.view)
        }
        
    }
    
    
}
