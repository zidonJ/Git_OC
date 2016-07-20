//
//  UIViewController+alert.swift
//  获取图片中的点
//
//  Created by zidon on 16/4/28.
//  Copyright © 2016年 zidon. All rights reserved.
//

import Foundation
import UIKit

typealias clicked = (Int)->()

extension NSObject{
    func alertNewAPI(title:String,message:String,buttonTitles:Array<String>,clickedIndex:clicked) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        for titleTemp in buttonTitles{
            alert.addAction(UIAlertAction.init(title: titleTemp, style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction) in
                clickedIndex(buttonTitles.indexOf(titleTemp)!)
            }))
        }
        let vc:UIViewController=(UIApplication.sharedApplication().windows.last?.rootViewController)!
        vc.presentViewController(alert, animated: true, completion: {
            print("弹出了alert")
        })
    }
}
