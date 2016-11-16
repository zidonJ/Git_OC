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
    func alertNewAPI(title:String,message:String,buttonTitles:Array<String>,clickedIndex:@escaping clicked) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        for titleTemp in buttonTitles{
            alert.addAction(UIAlertAction.init(title: titleTemp, style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) in
                clickedIndex(buttonTitles.index(of: titleTemp)!)
            }))
        }
        let vc:UIViewController=(UIApplication.shared.windows.last?.rootViewController)!
        vc.present(alert, animated: true, completion: {})
    }
}
