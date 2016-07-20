//
//  KindAndObjectVC.swift
//  MySwifProject
//
//  Created by Zidon on 15/3/24.
//  Copyright (c) 2015年 姜泽东. All rights reserved.
//

import UIKit

class KindAndObjectVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        class Shape {
            var numberOfSides = 0
            func simpleDescription() -> String {
                return "A shape with \(numberOfSides) sides."
            }
        }
        let shape = Shape()
        shape.numberOfSides = 7
        print("调用类内函数:\(shape.simpleDescription())")
        
        class NamedShape {
            var numberOfSides: Int = 0
            /*
                要给name初始化 否则会报错
                1.在构造器里面初始化
                2.var name: String?这种方式初始化
                3.直接赋值
            */
            var name: String
            init(name: String) {//构造方法
                self.name = name
            }
            func simpleDescription() -> String {
                return "A shape with \(numberOfSides) sides."
            }
        }
        //继承 与重写父类的方法
        class Square: NamedShape {
            var sideLength: Double
            init(sideLength: Double, name: String) {//构造方法
                self.sideLength = sideLength
                super.init(name: name)
                numberOfSides = 4
            }
            func area() -> Double {
                return sideLength * sideLength
            }
            //重写父类的方法要加/'override'/关键字
            override func simpleDescription() -> String {
                return "A square with sides of length \(sideLength)."
            }
        }
        let test = Square(sideLength: 5.2, name: "my test square")//调用构造方法
        /*
         *   处理变量的可选值时,你可以在操作(比如方法、属性和子脚本)之前加?。如果?之前的值
         *   是nil,?后面的东西都会被忽略,并且整个表达式返回 nil。否则,?之后的东西都会被运行。
         *   在这两种情况下,整个表达式的值也是一个可选值。
        */
        let optionalSquare: Square? = Square(sideLength: 2.5, name: "optional square")
        _ = optionalSquare?.sideLength
        
        class MyClass {
            var str:String
            required init(str:String) {
                self.str = str
            }
        }
        class MySubClass:MyClass
        {
            //子类定义新的初始化方法需要的两个步骤
            //1.实现父类的初始化方法
            required init(str:String) {
                super.init(str: str)
            }
            //2.
            init(test:Int) {
                super.init(str:String(test))
            }
        }
        print("面积:\(test.area())-----描述:\(test.simpleDescription())")
        
        //属性的get set方法  类的初始化
        class EquilateralTriangle: NamedShape {
            var sideLength: Double = 0.0
            init(sideLength: Double, name: String) {//构造方法
                self.sideLength = sideLength
                super.init(name: name)
                numberOfSides = 3//继承来的
            }
            var perimeter: Double {//get set方法
                get {
                    return 3.0 * sideLength
                }
                set {
                    sideLength = newValue / 3.0
                }
            }
            override func simpleDescription() -> String {
                return "An equilateral triagle with sides of length \(sideLength)"
            }
        }
        let triangle = EquilateralTriangle(sideLength: 3.1, name: "a triangle")//类构造器 调用构造方法
        triangle.perimeter = 9.9//set->get
        _=triangle.perimeter//get
        print(triangle.perimeter)
        
        //结构体
        struct FirstStruct{
            
        }
    }
    
    @IBAction func jump(sender: UIButton) {
        let vc=KvcAndKvoViewController();
        //跳转到KvcAndKvoViewController 时可以测试析构函数的执行
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
