//
//  ViewController.swift
//  正则表达式
//
//  Created by 姜泽东 on 2017/9/18.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let phoneNumRegex = "1[3578][0-9]{9}"
        let regular = try! NSRegularExpression(pattern: phoneNumRegex, options: NSRegularExpression.Options.caseInsensitive)
        let source = "15173265865/18551410506"
//        let matches:[NSTextCheckingResult] = regular.matches(in: source, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0, length: source.characters.count))
        
        let matches = regular.numberOfMatches(in: source, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0, length: source.characters.count))
        print(matches)
        
    }

    


}

