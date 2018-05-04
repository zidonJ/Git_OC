//
//  ViewController.swift
//  Test轮播图
//
//  Created by zidonj on 2017/3/14.
//  Copyright © 2017年 zidon. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UIScrollViewDelegate{

    let scroll:UIScrollView=UIScrollView()
    var array:Array<Any>=[]
    var width:CGFloat=0
    var height:CGFloat=0
    var currentIndex=0
    var preIndex=0
    var willIndex=0
    
    var arrCol = [UIColor.red,UIColor.green,UIColor.blue,UIColor.lightGray,UIColor.brown]
//    let arrCol = [UIColor.red,UIColor.green]
//    let arrCol = [UIColor.red]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        width = view.bounds.size.width
        height = view.bounds.size.height
        
        scroll.delegate=self
        scroll.frame=view.bounds
        scroll.contentSize = CGSize(width: width*(arrCol.count<2 ? 1:3), height: height)
        scroll.contentOffset=CGPoint(x: width, y: 0)
        scroll.isPagingEnabled=true
        view.addSubview(scroll)
        
        self.reloadData()
    }
    
    func reloadData() {
        
        for view in scroll.subviews {
            view.removeFromSuperview()
        }
        
        preIndex = self.getIndex(index: currentIndex-1)
        willIndex = self.getIndex(index: currentIndex+1)
        
        array.removeAll()
        array.append(arrCol[preIndex])
        array.append(arrCol[currentIndex])
        array.append(arrCol[willIndex])
        
        for index in 0..<array.count {
            let view:UIView=UIView()
            view.frame=CGRect.init(x: width*CGFloat(index), y: 0, width: width, height: height)
            view.backgroundColor=array[index] as? UIColor
            scroll.addSubview(view)
        }
        
        scroll.setContentOffset(CGPoint(x: self.width, y: 0), animated: false)
        
        print("当前页面:",currentIndex)
    }
    
    func getIndex(index:Int) -> Int {
        if index == -1 {
            return arrCol.count - 1;
        } else if (index == arrCol.count) {
            return 0;
        } else {
            return index;
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX:CGFloat = scrollView.contentOffset.x;
        if(contentOffsetX >= (2 * self.width)) {
            self.currentIndex=self.getIndex(index: self.currentIndex+1)
            self.reloadData()
        }
        if(contentOffsetX <= 0) {
            self.currentIndex=self.getIndex(index: self.currentIndex-1)
            self.reloadData()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scroll.setContentOffset(CGPoint(x: self.width, y: 0), animated: true)
    }
}

