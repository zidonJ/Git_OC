//
//  ViewController.swift
//  SimpleAlgorithm
//
//  Created by zidon on 16/3/9.
//  Copyright © 2016年 zidon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var sort1=[6,2,7,3,8,9]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var list: [Int] = Array()
        //生成一组随机整数
        for _ in 1...50 {
            list.append(Int(arc4random() % 100 + 1))
        }
        print(list)
        
        QuickSort(&list, first: 0, last: list.count - 1)
        print(list)
        
        print(self.branch(),__LINE__,__FUNCTION__)
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
    
    /**
     快速排序算法
     
     - parameter list:  数组
     - parameter first: 第一个元素下标
     - parameter last:  最后一个元素下标
     */
    func QuickSort(inout list: [Int], first: Int, last: Int) {
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
                j--
            }
            if i < j {
                list[i++] = list[j]
            }
            //找出来比key大的 并排到key后面
            while i < j && list[i] < key {
                i++
            }
            if i < j {
                list[j--] = list[i]
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
    func dropRepeat(inout array:[Int]){
        for i in array{
            for j in array{
                if array[i]==array[j]{
                    array[j] = -1
                }
            }
        }
    }
    ///找到重复元素次数最多的元素
    
}
