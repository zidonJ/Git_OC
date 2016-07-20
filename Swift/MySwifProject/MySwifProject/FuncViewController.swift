//
//  FuncViewController.swift
//  MySwifProject
//
//  Created by Zidon on 15/3/24.
//  Copyright (c) 2015年 姜泽东. All rights reserved.
//

import UIKit

class FuncViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //使用->来指定函数返回值-----返回值是一个String类型--------------------------
        func greet(name: String, day: String) -> String {
            return "Hello \(name), today is \(day)."
        }
        print(greet(name: "Bob", day: "Tuesday"))
        
        //使用一个元组来返回多个值----------------------------------------------------------
        func getGasPrices() -> (Double, Double, Double) {//利用元组返回多个值
            return (3.59, 3.69, 3.79)
        }
        let (s1,s2,s3)=getGasPrices()
        print("first:\(getGasPrices().1)--second:\(s2)")
        
        //函数的参数数量是可变的,用一个数组来获取它们:-----------
        func sumOf(numbers: Int...) -> Int {
            var sum = 0
            for number in numbers {
                sum += number
            }
            return sum
        }
        print("sumOf():\(sumOf())----sumOf(42, 597, 12):\(sumOf(numbers: 42, 597, 12))")
        
        //函数嵌套---------------------------------
        func returnFifteen() -> Int {
            var y = 10
            func add() {
                y += 5
            }
            add()
            return y
        }
        print("函数嵌套:\(returnFifteen())")
        
        //函数作为返回值----------------------------------------
        func makeIncrementer() -> ((Int,Int) -> Int) {
            func addOne(number: Int ,test: Int) -> Int {
                return test + number
            }
            return addOne
        }
        //使用函数返回值类型
        var increment = makeIncrementer()
        print("函数是返回值:\(increment(7,8))")
        
        //你可以在函数体中为每个参数定义默认值,当默认值被定义后，调用这个函数时可以忽略这个参数。
        func someFunction(parameterWithDefault: Int = 12) {
            // function body goes here
            // if no arguments are passed to the function call,
            // value of parameterWithDefault is 12
        }
        someFunction(parameterWithDefault: 6) // parameterWithDefault is 6
        
        //一个函数最多只能有一个可变参数。可以接受一个或多个值
        func arithmeticMean(numbers: Double...) -> Double {
            var total: Double = 0
            for number in numbers {
                total += number
            }
            return total / Double(numbers.count)
        }
        print(arithmeticMean(numbers: 1, 2, 3, 4, 5))
        print(arithmeticMean(numbers: 3, 8.25, 18.75))
        someFunction() // parameterWithDefault is 12
        
        
        //函数作为参数----------------------------------------------------------
        //通过在参数名前加关键字 var 来定义变量参数
        func hasAnyMatches(list: [Int], condition: (Int) -> Bool) -> Bool {
            for item in list {
                if condition(item) {//condition(item)为真的时候返回true
                    return true
                }
            }
            return false
        }
        
        func lessThanTen(number: Int) -> Bool {
            return number < 10
        }
        let numbers = [20, 19, 7, 12]
        print(hasAnyMatches(list: numbers, condition: lessThanTen))
        print("函数是参数:\(hasAnyMatches(list: numbers, condition: lessThanTen))")
        
        //泛型函数  可以比较的协议 'Comparable'------------------
        func isEquals<T:Comparable,U:Comparable>(a:T,b:T,c:U,d:U)->Bool{
            if a==b&&c==d{
                print("这是一段经典的旋律")
                    return true
            }else{
                print("fuck you")
                    return false
            }
        }
        
        if isEquals(a: 5, b: 5, c: "andrew", d: "andrew1") {
            print("lalalala")
        }
        
        
        //使用函数类型   forIncrement外部参数名 外部调用的时候必须要使用这个参数名字
        func makeIncrementor(forIncrement amount: Int) -> () -> Int {
            var runningTotal = 0
            func incrementor() -> Int {
                runningTotal += amount
                return runningTotal
            }
            return incrementor
        }
        //函数类型作为使用类型 赋值给变量 变量可以当函数使用
        let incrementByTen = makeIncrementor(forIncrement: 10)
        print(incrementByTen())
    }
}
