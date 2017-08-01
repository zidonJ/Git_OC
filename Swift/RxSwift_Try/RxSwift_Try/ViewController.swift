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
    
    @IBOutlet weak var driveField: UITextField!
    @IBOutlet weak var driveLabel: UILabel!
    
    
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
        }.throttle(0.1, scheduler: MainScheduler.instance)
        .bindTo(result.rx.text).disposed(by: disPoseBag)
        
        
        //PublishSubject -> 会发送订阅者从订阅之后的事件序列
        /*
         shareReplay它是以重播的方式通知自己的订阅者,防止map重复调用,即使订阅之前的序列也可以收到(收到可重播次数的事件序列)
         */
        let sequenceOfInts = PublishSubject<Int>()
        let aa = sequenceOfInts.map{ i -> Int in
            print("MAP---\(i)")
            return i * 2
        }.shareReplay(3)
        
        aa.subscribe {
            print("--1--\($0)")
        }.disposed(by: disPoseBag)

        sequenceOfInts.on(.next(1))
        sequenceOfInts.on(.next(2))
        
        //上面是订阅之前的事件序列,如果之前不订阅,是不会有触发事件的
        aa.subscribe {
            print("**2**\($0)")
        }.disposed(by: disPoseBag)
        
        sequenceOfInts.on(.next(3))
        sequenceOfInts.on(.next(4))
        aa.subscribe {
            print("!!3!!\($0)")
        }.disposed(by: disPoseBag)
        
        
        sequenceOfInts.on(.completed)
        
        /*
         在新的订阅对象订阅的时候会补发所有已经发送过的数据队列,bufferSize 是缓冲区的大小，决定了补发队列的最大值。如果 bufferSize 是1，那么新的订阅者出现的时候就会补发上一个事件，如果是2，则补两个.
         */
        let replaySubject = ReplaySubject<String>.create(bufferSize: 2)
        replaySubject.on(.next("a"))
        replaySubject.on(.next("b"))
        replaySubject.subscribe { (test) in
            print(test,"->ReplaySubject")
        }.disposed(by: disPoseBag)
        /*
         在新的订阅对象订阅的时候会发送最近发送的事件，如果没有则发送一个默认值。
         */
        let behaviorSubject = BehaviorSubject<String>.init(value: "z")
        behaviorSubject.on(.next("a"))
        behaviorSubject.on(.next("b"))
        behaviorSubject.subscribe { (test) in
            print(test,"->BehaviorSubject")
        }.disposed(by: disPoseBag)

        //Driver的drive方法与Observable的方法bindTo用法非常相似,在Observable中假如你要进行限流，你要用到方法throttle
        driveField.rx.text
            .asDriver().throttle(2)
            .drive(driveLabel.rx.text)
            .addDisposableTo(disPoseBag)
        
        
        let neverSequence = Observable<String>.never()
        
        let neverSequenceSubscription = neverSequence
            .subscribe { _ in
                print("This will never be printed")
        }
        
        neverSequenceSubscription.disposed(by: disPoseBag)
        
        //empty只发送完成消息
        Observable<Int>.empty()
            .subscribe { event in
                print(event,#line)
            }
            .disposed(by: disPoseBag)
        
        //just 是只包含一个元素的序列，它会先发送 .Next(value) ，然后发送 .Completed 。
        Observable.just("🔴")
            .subscribe { event in
                print(event,#line)
            }
            .disposed(by: disPoseBag)
        
        
        //of
        let disposeBag = DisposeBag()
        Observable.of("🐶", "🐱", nil,"🐭", "🐹")
            .subscribe(onNext: { (str) in
                print(str ?? "🈳️",#line,#function)
            }, onError: { (error) in
                print(error,#line,#function)
            }, onCompleted: {
                
            },onDisposed:{
                print("释放")
            }).disposed(by: disposeBag)
        
        //from 创建一个可观测序列的序列,如一个数组,字典,或一组。
        Observable.from(["🐶", "🐱", "🐭", "🐹"])
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        //创建一个定制的可观测序列。
        let myJust = { (element: String) -> Observable<String> in
            return Observable.create { observer in
                observer.on(.next(element))
                observer.on(.completed)
                return Disposables.create()
            }
        }
        
        myJust("🔴")
            .subscribe { print($0) }
            .disposed(by: disposeBag)
        
        //创建可观测序列
        Observable.range(start: 1, count: 10)
            .subscribe { print($0,#line) }
            .disposed(by: disposeBag)
        
        //创建一个可观测序列无限期发出给定的元素。
        Observable.repeatElement("🔴")
            .take(3)
            .subscribe(onNext: { print($0,#line) })
            .disposed(by: disposeBag)
        
        
        Observable.generate(
            initialState: 0,
            condition: { $0 < 3 },
            scheduler: CurrentThreadScheduler.instance,
            iterate: { $0 + 1 }
            )
            .subscribe(onNext: { print($0,#line) })
            .disposed(by: disposeBag)
        
        
        var count = 1
        
        let deferredSequence = Observable<String>.deferred {
            print("Creating \(count)")
            count += 1
            
            return Observable.create { observer in
                print("Emitting...")
                observer.onNext("🐶")
                observer.onNext("🐱")
                observer.onNext("🐵")
                return Disposables.create()
            }
        }
        
        deferredSequence
            .subscribe(onNext: { print($0,#line) })
            .disposed(by: disposeBag)
        
        deferredSequence
            .subscribe(onNext: { print($0,#line) })
            .disposed(by: disposeBag)
        
        
        //error
        enum TestError : Error {
            case test
        }
        
        Observable<Int>.error(TestError.test)
            .subscribe {
                print($0,#line)
            }
            .disposed(by: disposeBag)
        
        //doOn
        Observable.of("🍎", "🍐", "🍊", "🍋")
            .do(onNext: { (event) in
                print(event,#line)
            }, onError: { (error) in
                print(error,#line)
            }, onCompleted: { 
                print("完成",#line)
            }, onSubscribe: { 
                print("订阅",#line)
            }).subscribe { (event) in
                print(event,#line)
            }.disposed(by: disposeBag)
        
        //startWith
        Observable.of("🐶", "🐱", "🐭", "🐹")
            .startWith("1️⃣")
            .startWith("2️⃣")
            .startWith("3️⃣", "🅰️", "🅱️")
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        
        //merge
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
        
        Observable.of(subject1, subject2)
            .merge()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject1.onNext("🅰️")
        subject1.onNext("🅱️")
        subject2.onNext("①")
        subject2.onNext("②")
        subject1.onNext("🆎")
        subject2.onNext("③")
        
        
        //switchLatest
        let subject3 = BehaviorSubject(value: "⚽️")
        let subject4 = BehaviorSubject(value: "🍎")
        
        let variable = Variable(subject3)
        
        variable.asObservable()
            .switchLatest()
            .subscribe(onNext: { print($0,"->switchLatest") })
            .disposed(by: disposeBag)
        
        subject3.onNext("🏈")
        subject3.onNext("🏀")
        
        variable.value = subject4

        subject3.onNext("⚾️")

        subject4.onNext("🍐")
        
        //map
        Observable.of(1, 2, 3)
            .map { $0 * $0 }
            .subscribe(onNext: { print($0,#line) })
            .disposed(by: disposeBag)
        
        //flatMap
        struct Player {
            var score: Variable<Int>
        }
        
        let 👦🏻 = Player(score: Variable(80))
        let 👧🏼 = Player(score: Variable(90))
        
        let player = Variable(👦🏻)
        
        player.asObservable()
            .flatMap { $0.score.asObservable() } // Change flatMap to flatMapLatest and observe change in printed output
            .subscribe(onNext: { print($0,#line) })
            .disposed(by: disposeBag)
        
        👦🏻.score.value = 85
        
        player.value = 👧🏼
        // Will be printed when using flatMap, but will not be printed when using flatMapLatest
        👦🏻.score.value = 95
        👧🏼.score.value = 100
        
        Observable.from(["🐶", "🐱", "🐭", "🐹"])
            .flatMap { (event) -> Observable<String> in
                return Observable.of("🐶", "🐱", "🐭", "🐹")
            }.subscribe{
                print($0,#line)
            }.disposed(by: disposeBag)
        
        
        
        //scan
        Observable.of(10, 100, 1000)
            .scan(2) { aggregateValue, newValue in
                print(aggregateValue,newValue,"->scan")
                return aggregateValue + newValue
            }
            .subscribe(onNext: { print($0,"scan->",#line) })
            .disposed(by: disposeBag)
        
        
        //distinctUntilChanged
        Observable.of("🐱", "🐷", "🐱", "🐱", "🐱", "🐵", "🐱")
            .distinctUntilChanged()
            .subscribe(onNext: { print($0,"->distinctUntilChanged") })
            .disposed(by: disposeBag)
        
        //elementAt
        Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
            .elementAt(3)
            .subscribe(onNext: { print($0,"->elementAt") })
            .disposed(by: disposeBag)
        
        //single
        Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
            .single()
            .subscribe(onNext: { print($0,"->single") })
            .disposed(by: disposeBag)
        
        
        Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
            .single { $0 == "🐸" }
            .subscribe { print($0) }
            .disposed(by: disposeBag)
        
        Observable.of("🐱", "🐰", "🐶", "🐱", "🐰", "🐶")
            .single { $0 == "🐰" }
            .subscribe { print($0) }
            .disposed(by: disposeBag)
        
        Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
            .single { $0 == "🔵" }
            .subscribe { print($0) }
            .disposed(by: disposeBag)
        
        //take
        //发出只有指定数量的元素从一个观察序列的开始
        Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
            .take(3)
            .subscribe(onNext: { print($0,"->take") })
            .disposed(by: disposeBag)
        
        Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
            .takeLast(3)
            .subscribe(onNext: { print($0,"->takeLast") })
            .disposed(by: disposeBag)
        
        
        Observable.of(1, 2, 3, 4, 5, 6)
            .takeWhile { $0 < 4 }
            .subscribe(onNext: { print($0,"->takeWhile") })
            .disposed(by: disposeBag)
        
        //takeUntil
        let sourceSequence = PublishSubject<String>()
        let referenceSequence = PublishSubject<String>()
        
        sourceSequence
            .takeUntil(referenceSequence)
            .subscribe { print($0,"->takeUntil") }
            .disposed(by: disposeBag)
        
        sourceSequence.onNext("🐱")
        sourceSequence.onNext("🐰")
        sourceSequence.onNext("🐶")
        
        referenceSequence.onNext("🔴")
        
        sourceSequence.onNext("🐸")
        sourceSequence.onNext("🐷")
        sourceSequence.onNext("🐵")
        
        
        //skip
        Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
            .skip(2)
            .subscribe(onNext: { print($0,"->skip") })
            .disposed(by: disposeBag)
        
        Observable.of(1, 2, 3, 4, 5, 6)
            .skipWhile { $0 < 4 }
            .subscribe(onNext: { print($0,"->skipWhile") })
            .disposed(by: disposeBag)
        
        
        Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
            .skipWhileWithIndex { element, index in
                index < 3
            }
            .subscribe(onNext: { print($0,"->skipWhileWithIndex") })
            .disposed(by: disposeBag)
        
        
        let sourceSequence1 = PublishSubject<String>()
        let referenceSequence1 = PublishSubject<String>()
        
        sourceSequence1
            .skipUntil(referenceSequence1)
            .subscribe(onNext: { print($0,"->skipUntil") })
            .disposed(by: disposeBag)
        
        sourceSequence1.onNext("🐱")
        sourceSequence1.onNext("🐰")
        sourceSequence1.onNext("🐶")
        
        referenceSequence1.onNext("🔴")
        
        sourceSequence1.onNext("🐸")
        sourceSequence1.onNext("🐷")
        sourceSequence1.onNext("🐵")
        
        //toArray
        Observable.range(start: 1, count: 10)
            .toArray()
            .subscribe { print($0,"->toArray") }
            .disposed(by: disposeBag)
        
        //reduce
        Observable.of(10, 100, 1000)
            .reduce(2, accumulator: *)
            .subscribe(onNext: { print($0,"->reduce") })
            .disposed(by: disposeBag)
        

        //concat
        let subject7 = BehaviorSubject(value: "🍎")
        let subject8 = BehaviorSubject(value: "🐶")
        
        let variable1 = Variable(subject7)
        
        variable1.asObservable()
            .concat()
            .subscribe { print($0,"->concat") }
            .disposed(by: disposeBag)
        
        subject7.onNext("🍐")
        subject7.onNext("🍊")
        
        variable1.value = subject8
        
        subject8.onNext("I would be ignored")
        subject8.onNext("🐱")

        subject7.onCompleted()
        
        subject8.onNext("🐭")
    }
    
}

