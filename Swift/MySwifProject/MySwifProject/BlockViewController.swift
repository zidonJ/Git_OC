//
//  BlockViewController.swift
//  MySwifProject
//
//  Created by zidon on 15/5/7.
//  Copyright (c) 2015年 姜泽东. All rights reserved.
//

import UIKit


//无参无返回值
typealias funcBlock = () -> () //或者 () -> Void
//返回值是String
typealias funcBlockA = (Int,Int) -> String
//返回值是一个函数指针,入参为String
typealias funcBlockB = (Int,Int) -> (String)->()
//返回值是一个函数指针,入参为String 返回值也是String
typealias funcBlockC = (Int,Int) -> (String)->String

class BlockViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor=UIColor.red
        
        //闭包----------------
        /*
            闭包的格式
         1.花括号 2.（参数类型） 3.返回值 类型 4.闭包内的操作
         { (parameters) -> returnType in statements }
         */
        
        var numbers = [20, 19, 7, 12]
        print("闭包测试:",numbers)
        let mapNumbers = numbers.map({
            (number: Int) -> Int in
            let result = 3 * number
            return result
        })
        
//        let sortNumbers = numbers.sort({
//            (number1: Int,number2: Int) -> Bool in
//            return number1>number2;
//        })
        //闭包变形1
//        let sortNumbers = numbers.sort({
//            number1,number2 in
//            return number1>number2;
//        })
        
        //闭包变形2
//        let sortNumbers = numbers.sort({number1,number2 in number1>number2})
       
        //闭包变形3
//        let sortNumbers = numbers.sorted(by: {$0>$1})
        
        //闭包变形4
        let sortNumbers = numbers.sorted()
        
        print("闭包测试:",mapNumbers,sortNumbers)
        
        class blockDemo{
            //block作为属性变量
            var blockProperty : (Int,Int) -> String = {
                a,b in return String(a+b)/**/
            } // 带初始化方式
            
            
            var blockPropertyNoReturn : (String) -> () = {
                param in
                print("block打印参数:\(param)")
            }
            
            var blockPropertyA : funcBlockA?  //这写法就可以初始时为nil了,因为生命周其中，(理想状态)可能为nil所以用?
            var blockPropertyB : funcBlockB!  //这写法也可以初始时为nil了,因为生命周其中，(理想状态)认为不可能为nil,所以用!
            
            init()
            {
                /*
                blockPropertyA = nil , blockPropertyB = nil
                blockProperty = (Function) , blockPropertyNoReturn = (Function)
                */
                print("blockPropertyA = \(blockPropertyA) , blockPropertyB = \(blockPropertyB)")
                print("blockProperty = \(blockProperty) , blockPropertyNoReturn = \(blockPropertyNoReturn)")
            }
            
            func testProperty(tag:Int)
            {
                switch (tag)
                {
                case 1:
                    self.blockPropertyNoReturn("OK GOOD")
                case 2:
                    if  (self.blockPropertyA != nil)
                    {
                        let result = self.blockPropertyA!(7,8)
                        print("result = \(result)")
                    }
                case 3:
                    if let _ = self.blockPropertyB
                    {
                        let fc = self.blockPropertyB(1,2)
                        fc("输出")
                    }
                default:
                    let ret = self.blockProperty(3,4)
                    print("blockProperty的打印:\(ret)")
                }
            }
            
            //block作为函数参数
            func testBlock(blockfunc:funcBlock!,blockfunc1:funcBlock!)//使用!号不需要再解包
            {
                if let _ = blockfunc
                {
                    blockfunc() //无参无返回
                    blockfunc1()
                }
            }
            
            func testBlockA(blockfunc:funcBlockA!)
            {
                if let _ = blockfunc
                {
                    let retstr = blockfunc(5,6)
                    print(retstr)
                }
            }
            
            func testBlockB(blockfunc:funcBlockB!)
            {
                if let _ = blockfunc  
                {  
                    let retfunc = blockfunc(5,6)  
                    retfunc("结果是")  
                }
            }  
            
            func testBlockC(blockfunc:funcBlockC!)  
            {  
                if let _ = blockfunc  
                {  
                    let retfunc = blockfunc(5,6)  
                    let str = retfunc("最终果结是")  
                    print(str)  
                }  
            }  
        }
        
        
        //=================================================
        /*
        
        
        ＝＝＝＝＝＝＝＝＝＝＝＝＝＝设置block属性＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
        3*100+4 = 304
        input param value is : OK GOOD
        result = 7*100+8*200 = 2300
        sumprint func print:parame :输出 1 + 2 = 3
        ＝＝＝＝＝＝＝＝＝＝＝＝＝＝属性block完成＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
        ＝＝＝＝＝＝＝＝＝＝＝＝＝＝函数block为nil时无输出＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
        ＝＝＝＝＝＝＝＝＝＝＝＝＝＝函数block操作＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
        无参无返回值block 执行
        5*400 + 6*1000 is 8000
        sumprint func print:param
        */
        var bk = blockDemo()
        //block设置前,啥也没有输出
        bk.testProperty(tag: 0)
        bk.testProperty(tag: 1)
        bk.testProperty(tag: 2)
        bk.testProperty(tag: 3)
        print("＝＝＝＝＝＝＝＝＝＝＝＝＝＝设置block属性＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝")
        
        bk.blockProperty = {
            (a :Int,b:Int) -> String in
            let c = a*100+b
            return "\(a)*100+\(b) = \(c)"
        }
        
        bk.blockPropertyNoReturn = {
            (param:String) -> () in
            print("input param value is : \(param)")
        }
        
        
        bk.blockPropertyA = {
            (a:Int,b:Int) -> String in
            let c = a*100+b*200
            return "\(a)*100+\(b)*200 = \(c)"
        }
        
        
        bk.blockPropertyB = {
            (a:Int,b:Int) -> (String)->() in
            func sumprint(result:String)
            {
                let c = a + b;
                print("sumprint func print:parame :\(result) \(a) + \(b) = \(c)")
            }
            
            return sumprint
        }
        bk.testProperty(tag: 3)
        
        
        bk.testProperty(tag: 0)
        bk.testProperty(tag: 1)
        bk.testProperty(tag: 2)
        
        print("＝＝＝＝＝＝＝＝＝＝＝＝＝＝属性block完成＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝")
        
        print("＝＝＝＝＝＝＝＝＝＝＝＝＝＝函数block为nil时无输出＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝")
        //bk.testBlock(nil)
        bk.testBlockA(blockfunc: nil)
        bk.testBlockB(blockfunc: nil)
        bk.testBlockC(blockfunc: nil)
        print("＝＝＝＝＝＝＝＝＝＝＝＝＝＝函数block操作＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝")
        bk.testBlock(blockfunc: {
            print("adsf")
            }) { 
            print("adsf11111")
        }
        
        bk.testBlock(blockfunc: {
            
            },blockfunc1: {
        
        })

        bk.testBlockA(blockfunc: {
            (a:Int,b:Int) -> String in
            let c = a*400+b*1000
            return "\(a)*400 + \(b)*1000 is \(c)"
        })
        
        bk.testBlockB(blockfunc: {
            (a:Int,b:Int) -> (String)->() in
            func sumprint(result:String)
            {  
                let c = a / b;  
                print("sumprint func print:parame :\(result) \(a) / \(b) = \(c)")
            }  
            
            return sumprint  
        })  
        
        bk.testBlockC(blockfunc: {
            (a:Int,b:Int) -> (String)->String in  
            func sumrsult(res:String) -> String  
            {  
                let c = a*a+b*a  
                return "\(res) \(a)*\(a)+\(b)*\(a) = \(c)"  
            }  
            return sumrsult  
        })
        
        /*
         /逃逸闭包---------------------/
         闭包只能在函数体中被执行，不能脱离函数体执行，所以编译器明确知道运行时的上下文
         */
        //声明一个存放函数的数组
        var functionArray: [() -> Void] = []
        //定义一个接收闭包参数的函数，如果定义非逃逸函数 func doSomething(@noescape paramClosure:() -> Void) 就会编译错误
        func doSomething(paramClosure:@escaping () -> Void){
            //参数可以传递到函数外部的数组中
            functionArray.append(paramClosure)
        }
        
        
        func doSomething1( paramClosure: () -> Void){
            //functionArray.append(paramClosure)  这样的代码会报错  这个是不接受闭包逃逸的
            paramClosure()
        }
        
        //调用函数
        
        doSomething(paramClosure: {print("Hello world")})
        
        doSomething(paramClosure: {print("Hello LvesLi")})
        
        //逃逸调用闭包
        for closurePrama in functionArray {
            
            print("\(closurePrama)")
            
        }
        
        
    }
}
