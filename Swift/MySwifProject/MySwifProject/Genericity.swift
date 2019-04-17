//
//  Genericity.swift
//  MySwifProject
//
//  Created by zidonj on 2018/11/9.
//  Copyright © 2018 姜泽东. All rights reserved.
//

import UIKit

struct Stack<Element> {
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
}

class Genericity {
    
    init() {
        
        var stack = Stack<String>()
        stack.push("1")
        stack.push("2")
        stack.push("3")
        print(stack.pop())
    }
    
}

extension Collection where Iterator.Element: Sequence {
    
    public func makeIterator() -> Iterator {
        return "1" as! Self.Iterator
    }
}

protocol TTT {
    
    //MARK:'associatedtype'是一个关联类型 为协议中的某个类型提供了一个占位名
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
    
    associatedtype Element: IteratorProtocol where Element.Element == Item
    func makeIterator() -> Element
}
