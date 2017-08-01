//
//  ViewController.swift
//  SimpleAlgorithm
//
//  Created by zidon on 16/3/9.
//  Copyright © 2016年 zidon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var sortField: UITextField!
    @IBOutlet weak var sortedShow: UILabel!
    var sort1=[1,10,20,5,12,3,9,8,6]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                
        
//        QuickSort(&list, first: 0, last: list.count - 1)
//        print("快速排序:",list)
//        bubbleSort(list: &sort1)
//        print("冒泡排序:",sort1)
        selectSort(list: &sort1)
        print("选择排序:",sort1)
        
        print(self.branch(),#line,#function)
    }
    
    func branch() -> String {
        
        var str = ""
        str += "1"
        defer { str += "2" }
        let counter = 3;
        
        if counter > 0 {
            
            str += "3"
            defer { str += "4" }
            str += "5"
        }
        str += "6"
        return str
    }
    
    
    /// 冒泡排序算法
    ///
    /// - Parameter list:
    func bubbleSort(list: inout[Int]) {
        for _ in 0..<list.count {
            
            for  j in 0..<list.count-1 {
                
                if list[j] > list[j+1] {
                    let temp = list[j]
                    list[j] = list[j+1]
                    list[j+1] = temp
                }
            }
        }
    }
    
    
    /// 选择排序算法
    ///
    /// - Parameter list:
    /// - Returns:
    func selectSort(list: inout[Int]) {
        for i in 0..<list.count {
            
            for  j in (i+1)..<list.count {
                
                if list[i] > list[j] {
                    let temp = list[i]
                    list[i] = list[j]
                    list[j] = temp
                }
            }
        }
    }
    
    /**
     快速排序算法
     
     - parameter list:  数组
     - parameter first: 第一个元素下标
     - parameter last:  最后一个元素下标
     */
    func QuickSort(_ list: inout [Int], first: Int, last: Int) {
        var i, j, key: Int
        if first >= last {
            return;
        }
        i = first
        j = last
        key = list[i]
        while i < j {
            //找出来比key小的 并排到key前面
            while i < j && list[j] > key {
                j -= 1
            }
            if i < j {
                i += 1
                list[i] = list[j]
            }
            //找出来比key大的 并排到key后面
            while i < j && list[i] < key {
                i+=1
            }
            if i < j {
                j -= 1
                list[j] = list[i]
            }
        }
        list[i] = key
        //将key前面元素递归的进行下一轮排序
        if first < i - 1 {
            QuickSort(&list, first: first, last: i - 1)
        }
        //将key后面的元素递归的进行下一轮排序
        if i + 1 < last {
            QuickSort(&list, first: i + 1, last: last)
        }
    }
    ///去掉重复算法
    var arrayRepeat:[Int]=[1,2,2,3,4,5,7,9,0,6,4,5,7,8,2,4,5,7,9,0,6,4,3,8,6,4]
    func dropRepeat(_ array:inout [Int]){
        for i in array{
            for j in array{
                if array[i]==array[j]{
                    array[j] = -1
                }
            }
        }
    }
    ///阶乘算法
    @IBAction func sort(_ sender: Any) {
        
        sortedShow.text = test().joined(separator: ",")
        
    }
    
    func test() -> [String] {
        
        var array:[String] = (sortField.text?.components(separatedBy: ","))!
        for i in 0..<array.count {
            
            for  j in (i+1)..<array.count {
                
                if Int(array[i])! > Int(array[j])! {
                    let temp = array[i]
                    array[i] = array[j]
                    array[j] = temp
                }
            }
        }
        
        
        return array
    }
    
    @IBOutlet weak var sort: UIButton!
}
