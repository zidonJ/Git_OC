//
//  SubscriptTest.swift
//  ARKitUse
//
//  Created by 姜泽东 on 2017/9/26.
//  Copyright © 2017年 MaiTian. All rights reserved.
//  这个类是swift的下标测试 与AR无关

import UIKit

class SubscriptTest: NSObject {
    
    enum MealTime {
        case Breakfast
        case Lunch
        case Dinner
    }
    
    var meals: [MealTime : String] = [:]
    
    subscript(requestedMeal : MealTime) -> String {
        get {
            if let thisMeal = meals[requestedMeal] {
                return thisMeal
            } else {
                return "Ramen"
            }
        }
        
        set(newMealName) {
            meals[requestedMeal] = newMealName
        }
    }
}

class UseSubscriptTest: NSObject {
    
    override init() {
        
        let monday = SubscriptTest()

//        monday.meals[.Breakfast] = "Toast"
//
//        if let someMeal = monday.meals[.Breakfast] {
//            print(someMeal)
//        }
        //下标取值和赋值的参数放在[]内
        monday[.Breakfast] = "Toast"
        print(monday[.Breakfast])
    }
    
}
