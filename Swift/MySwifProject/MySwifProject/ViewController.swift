//
//  ViewController.swift
//  MySwifProject
//
//  Created by Zidon on 15/3/6.
//  Copyright (c) 2015年 姜泽东. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor=UIColor.red;
        let swt:Double=100
        print("hello world",swt)
        //修改字符串
        var str:String!="说好破晓前忘掉"
    
        print("字符串索引位置的字符:",str[str.startIndex],str[str.index(before: str.endIndex)])
        //插入字符串
        str.insert(contentsOf: "花田里犯了错,".characters, at: str.startIndex)
        str.insert(".", at: str.endIndex)//插入字符
        print("可变字符串:",str)
        
        //"endIndex" 是末尾0的位置 往左一次递减,是负数
//        let range = str.endIndex.
//        let range = str.endIndex.advancedBy(n: -6)..<str.endIndex
//        str.removeRange(range)
//        print("移除子字符串:",str)
        str.remove(at: str.index(before: str.endIndex))
        print("移除单个字符:",str)
        
        //字符串比较
        let quotation = "We're a lot alike, you and I."
        let sameQuotation = "We're a lot alike, you and I."
        if quotation==sameQuotation {
            print("这是一个字符串比较相等")
        }
        
        //字符串的Unicode
        /*
            前三个10进制codeUnit值 (68, 111, 103) 代表了字符D、o和 g，它们的 UTF-8 表示与 ASCII 表示相同。 接下来的三个10进制codeUnit值 (226, 128, 188) 是DOUBLE EXCLAMATION MARK的3字节 UTF-8 表示。 最后的四个codeUnit值 (240, 159, 144, 182) 是DOG FACE的4字节 UTF-8 表示
        */
        let dogString = "Dog‼🐶"
        for codeUnit in dogString.utf8 {
            print("字符串的Unicode:","\(codeUnit) ")
            //print("字符串的Unicode:","\(codeUnit) ", terminator: "--")
        }
        
        //----------以上是字符串-------
        
        //集合
        /*
        集合set_intersect: ["Rock"]
        集合set_exclusiveOr: ["Classical", "Jazz", "Beautiful", "Hip hop"]
        集合set_union: ["Rock", "Classical", "Jazz", "Beautiful", "Hip hop"]
        集合set_subtract: ["Classical", "Hip hop"]
        */
        
        ///   初始化
        let arr:Array<String>=[String]()
        print(arr)
        let dic1:Dictionary<String , String>=[String:String]()
        print(dic1)
        
        let setA:Set<String>=["Rock", "Classical", "Hip hop"]
        let setB:Set<String>=["Rock", "Jazz", "Beautiful"]
        
        //两个集合的交叉集合
        let set_intersect=setA.intersection(setB)
        
        //出去两个集合相同的元素,剩余的组成一个新集合
        let set_exclusiveOr=setA.symmetricDifference(setB)
        
        //合并两个集合,形成新集合
        let set_union=setA.union(setB)
        
        //不在B集合中得值 创建新集合
        let set_subtract=setA.subtracting(setB)
        print("集合set_intersect:",set_intersect)
        print("集合set_exclusiveOr:",set_exclusiveOr)
        print("集合set_union:",set_union)
        print("集合set_subtract:",set_subtract)
        
        
        let width=150
        let str_width=str+String(width)//强制类型转换
        let strLeft="琥珀色的月,结了霜的泪"
        let strRight="我会记得这段岁月"
        let strFormat=strLeft+strRight
        print(str_width,strFormat)
        
        let apples=5
        let oranges=8
        let appleSum="I have \(apples) apples"
        let orangeSum="I have \(oranges+apples) oranges"
        print(appleSum,orangeSum)
        
        //数组--------------------------------------------
        var shoppingList=["哈喽","你好吗","我是周杰伦"]
        shoppingList[1]="fuck you"//存在则覆盖 不存在就添加失败
        
        //字典--------------------------------------------
        //创建一个空字典 它的键是Int型,值是String型。
        var namesOfIntegers = [Int: String]()
        // namesOfIntegers 现在包含一个键值对
        namesOfIntegers[16] = "sixteen"
        // namesOfIntegers 又成为了一个 [Int: String] 类型的空字典
        namesOfIntegers = [:]
        
        print(namesOfIntegers)
        var dictionary=[
            "1":"one",
            "2":"two",
        ]
        //dictionary["1"]=nil//可以代表移除"1"的key,value
        //dictionary.removeValueForKey("1")
        //dictionary.updateValue("1", forKey: "first")
        for (index, value) in shoppingList.enumerated() {
            print("Item \(index): \(value)")
        }
        
        dictionary["3"]="three"//存在则覆盖 不存在就添加
        //NSLog("%@-%@",shoppingList, dictionary)
        
        for (key,value) in dictionary{
            print("for in 字典:\(key,value)")
            if value=="one"{//字符串判断变了
                print("这样可以吧")
            }
        }
        
        
        /// for 循环和区间运算符
        let a=10,b=12
        for index in a...b {
            print(index,"a到b的闭区间")
        }
        for index in a..<b {
            print(index,"a到b的半闭半开区间，包含a但不包含b")
        }
        
        let individualScores = [75 , 43, 103, 87, 12]
        var teamScore = 0
        for score in individualScores {
            if score > 50 {
                teamScore += 3
            } else {
                teamScore += 1
            }
        }
        print(teamScore)
        let airports: Dictionary<String, String> = ["TYO":"Tokyo", "DUB": "Dublin"]
        print(airports)
        var dic:Dictionary<Int,String>=[1:"one",2:"two"]
        print("'int'型的key可以么:\(dic)----\(dic[1]!)")
        
        
        //字符串--------------------------------------------
        let optionalString: String? = "Hello"
        //?? 控制合并运算符
        print(optionalString ?? "optionalString的值为空")
        var optionalName: String? = "JohnAppleseed"
        optionalName=nil;//即使nil也不会崩溃
        var greeting = "Hello!"
        if let name = optionalName {
            greeting = "Hello, \(name)"
        }
        print("-----:\(greeting)")
        
        //元组3种初始化和使用形式--------------------------------------------
        let student1=("1001","张三",30,"90")
        print("学生:\(student1.1)-学号:\(student1.0)-年龄:\(student1.2)-分数:\(student1.3)")
        
        let (id,name,age,score)=student1;
        print("学生:\(name)-学号:\(id)-年龄:\(age)-分数:\(score)")
        
        
        let (userid,userName,height,userAge):(Int,String,Int,Int)=(3004,"zidon",173,28)
        print(userid,userName,height,userAge)
        
        //switch--------------------------------------------
        let vegetable = "red pepper"
        switch vegetable {
            case "celery":
                let vegetableComment = "Add some raisins and make ants on a log."
            print(vegetableComment)
            case "cucumber", "watercress"://两者都是条件
                let vegetableComment = "That would make a good tea sandwich."
            print(vegetableComment)
            case let x where x.hasSuffix("pepper"):
                let vegetableComment = "Is it a spicy \(x)?"
            print(vegetableComment)
            default:
                let vegetableComment = "Everything tastes good in soup."
            print(vegetableComment)
        }
    }
}

