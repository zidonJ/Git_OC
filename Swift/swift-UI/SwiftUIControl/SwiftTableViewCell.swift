//
//  SwiftTableViewCell.swift
//  SwiftUIControl
//
//  Created by zidon on 15/5/6.
//  Copyright (c) 2015年 zidon. All rights reserved.
//

import UIKit

protocol myDelegate{
    func swiftDelegateSendObjc(a:AnyObject)
}

typealias myFirstSwiftBlock = (String) ->String

/*
    //无参无返回值
    typealias funcBlock = () -> () //或者 () -> Void
    //返回值是String
    typealias funcBlockA = (Int,Int) -> String
    //返回值是一个函数指针，入参为String
    typealias funcBlockB = (Int,Int) -> (String)->()
    //返回值是一个函数指针，入参为String 返回值也是String
    typealias funcBlockC = (Int,Int) -> (String)->String
*/

class SwiftTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapGesture=UITapGestureRecognizer(target: self, action: Selector(("testFunc:")))
        //tapGesture.numberOfTouchesRequired=2;
        leftImage.addGestureRecognizer(tapGesture)
    }
    var swiftDelegate:myDelegate?
    func testFunc(sender : UIGestureRecognizer){
        //block 使用
        let str=swiftBlock!(cellContent.text!)
        print(str)
        //代理使用
        swiftDelegate?.swiftDelegateSendObjc(a: "是喜还是忧,都是我的独家感受.爱情或许荒谬,却可以永垂不朽." as AnyObject)
    }
    override func didMoveToWindow() {
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
//    var swiftBlock:myFirstSwiftBlock={
//        a in
//        return "\(a)就是\(a)啊"
//    }
    
    var swiftBlock:myFirstSwiftBlock?
    
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var cellContent: UILabel!//这样声明的设置文字时可以不用加"!"
    
    var _textContent111:String?
    
    
    var textContent:String?{
        get {
            return _textContent111
        }
        set(newValue) {
            _textContent111=newValue!
            updateUI()
        }
//        willSet{
//            updateUI()
//            print("Will set an new value \(newValue!) to age")
//        }
//        didSet{
//            print("age filed changed form \(oldValue) to \'新值'")
//        }
    }
    func updateUI(){
        if let str=self.textContent{
            //println("这是一段经典的旋律"+str)
            self.cellContent.text=String(format: "终于知道怎么用swift的get_set方法了:%@", str)
        }
    }
}
