//
//  ViewController.swift
//  UndoManaager撤销
//
//  Created by 姜泽东 on 2017/11/1.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    @IBOutlet weak var click: UIButton!
    @IBOutlet weak var setTitle: UIButton!
    
    let doManager = UndoManager()
    var titleText:NSInteger = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        doManager.levelsOfUndo = 0
    }
    
    @objc
    func setBtnTitle(title:String) {
        
        let currentTitle = setTitle.titleLabel?.text ?? ""
        if currentTitle != title {
            doManager.registerUndo(withTarget: self, selector: #selector(setBtnTitle(title:)), object: setTitle.titleLabel?.text)
            setTitle.setTitle(title, for: .normal)
        }
        setTitle.setTitle(title, for: .normal)
    }
    
    @IBAction func clickBtn(_ sender: UIButton) {
        
        titleText += 1
        setBtnTitle(title: String(format: "%d", titleText))
    }
    
    @IBAction func undoBtn(_ sender: UIButton) {
        doManager.undo()
    }
    
    @IBAction func redoBtn(_ sender: UIButton) {
        doManager.redo()
        
    }
    
    
}

