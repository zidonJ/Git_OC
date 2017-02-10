//
//  ViewController.swift
//  RxSwift_Try
//
//  Created by zidonj on 2017/2/10.
//  Copyright © 2017年 zidon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var txf1: UITextField!
    @IBOutlet weak var txf2: UITextField!
    @IBOutlet weak var txf3: UITextField!
    @IBOutlet weak var result: UILabel!
    
    //事件的释放,会在该对象释放的时候释放绑定监听事件
    let disPoseBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let a = Variable(1)
        let b = Variable(2)
        let c = Observable.combineLatest(a.asObservable(),b.asObservable()) {$0 + $1}
            .filter{$0 > 0}
            .map {
                "\($0) is positive"
            }
        
        c.subscribe(onNext: { print($0) }).disposed(by: disPoseBag)
        
        a.value = 4
        //此时获取到的值是小于零的,过滤起作用
        b.value = -8
        
        Observable.combineLatest(txf1.rx.text.orEmpty,txf2.rx.text.orEmpty,txf3.rx.text.orEmpty) {
            (Int($0) ?? 0)+(Int($1) ?? 0)+(Int($2) ?? 0)
        }.map {
            $0.description
        }.bindTo(result.rx.text).disposed(by: disPoseBag)
        
        
        let sequenceOfInts = PublishSubject<Int>()
        let aa = sequenceOfInts.map{ i -> Int in
            print("MAP---\(i)")
            return i * 2
        }.shareReplay(1)
        
        aa.subscribe {
            print("--1--\($0)")
        }

        sequenceOfInts.on(.next(1))
        sequenceOfInts.on(.next(2))
        let cc = aa.subscribe {
            print("**2**\($0)")
        }
//        sequenceOfInts.on(.next(3))
//        sequenceOfInts.on(.next(4))
//        let dd = aa.subscribe {
//            print("!!3!!\($0)")
//        }
//        sequenceOfInts.on(.completed)
        
    }
}

