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
    var sort1=[1,20,10,5,12,43,9,68,16]
//    var sort1=[2,1,3,8,6]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                
//        quickSort(&sort1, first: 0, last: sort1.count - 1)
//        print("快速排序:",sort1)
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
    
    
    /*
     冒泡排序:它重复地走访过要排序的元素列，依次比较两个相邻的元素，如果他们的顺序（如从大到小、首字母从A到Z）错误就把他们交换过来。
     走访元素的工作是重复地进行直到没有相邻元素需要交换，也就是说该元素列已经排序完成。
     时间复杂度:O(n^2)
     */
    func bubbleSort(list: inout[Int]) {
        
        var stopFlag:Bool//对冒泡排序优化
        
        for i in 0...(list.count - 1) {
            // stopFlag用于优化冒泡排序 减少已经有序的集合的遍历次数
            stopFlag = false
            for  j in 0...(list.count - i - 2) {
                
                if list[j] > list[j+1] {
                    let temp = list[j]
                    list[j] = list[j+1]
                    list[j+1] = temp
                    stopFlag = true
                }
            }
            if !stopFlag {
                break
            }
        }
    }
    
    /*
     选择排序:每一次从待排序的数据元素中选出最小（或最大）的一个元素，存放在序列的起始位置，然后，再从剩余未排序元素中继续寻找最小（大）元素，
     然后放到已排序序列的末尾。
     时间复杂度:O(n^2)
     */
    
    func selectSort(list: inout[Int]) {
        
        for i in 0..<list.count - 1 {
            
            var minIndex = i
            
            for  j in (i+1)..<list.count {
                
                if list[j] < list[minIndex] {
                    minIndex = j
                }
            }
            if minIndex != i {
                let temp = list[i]
                list[i] = list[minIndex]
                list[minIndex] = temp
            }
        }
    }
    
    /**
     快速排序算法:通过一趟排序将要排序的数据分割成独立的两部分，其中一部分的所有数据都比另外一部分的所有数据都要小，
     然后再按此方法对这两部分数据分别进行快速排序，整个排序过程可以递归进行，以此达到整个数据变成有序序列。
     O(n*logn)-平均时间复杂度
     O(n*n)-最坏时间复杂度
     O(logn~n)空间复杂度
     - parameter list:  数组
     - parameter first: 第一个元素下标
     - parameter last:  最后一个元素下标
     */
    func quickSort(_ list: inout [Int], first: Int, last: Int) {
        
        if first >= last || list.count <= 1{
            return
        }
        
        var i = first, j = last, key: Int , temp:Int
        
        key = list[first]
        
        while i < j {
            while (i<j && list[j] >= key) {
                j -= 1;
            }
            
            while (i<j && list[i] <= key) {
                i += 1;
            }
            
            if i<j {
                temp = list[i]
                list[i] = list[j]
                list[j] = temp;
            }
        }
        
        list[first] = list[i]
        list[i] = key
        
        quickSort(&list, first: first, last: i-1)
        quickSort(&list, first: i+1, last: last)
    }
    
    /*
     归并排序 两两归并
     O(n*logn)-平均时间复杂度
     O(n*logn)-最坏时间复杂度
     O(n)空间复杂度
     */
    
    
    /*
     堆排序 二叉树
     O(n*logn)-平均时间复杂度
     O(n*logn)-最坏时间复杂度
     O(1)空间复杂度
     */
    
    
    ///去掉重复算法
    var arrayRepeat:[Int]=[1,2,2,3,4,5,7,9,0,6,4,5,7,8,2,4,5,7,9,0,6,4,3,8,6,4]
    func dropRepeat(_ array:inout [Int]){
        for i in array{
            for j in array{
                if array[i] == array[j]{
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
