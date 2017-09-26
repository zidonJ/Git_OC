//
//  Controller+extension.swift
//  MySwifProject
//
//  Created by 姜泽东 on 2017/9/26.
//  Copyright © 2017年 姜泽东. All rights reserved.
//

import UIKit

private var keyStore:Void?

extension UIViewController {
    
    
    var vcName:String {
        
        set{
            
            objc_setAssociatedObject(self, &keyStore, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get{
            
            return (objc_getAssociatedObject(self, &keyStore) as? String) ?? ""
        }
    }
}
