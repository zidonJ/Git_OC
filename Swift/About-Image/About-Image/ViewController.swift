//
//  ViewController.swift
//  About-Image
//
//  Created by zidonj on 2017/3/22.
//  Copyright © 2017年 zidon. All rights reserved.
//

import UIKit
import ImageIO
import AssetsLibrary

class ViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var temp: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let image:UIImage = UIImage.init(named: "1.jpg")!
        
        imgView.image = image.pixeFace(image: image)
        
        imgView.getColor(color: { [weak self] color in
            self?.temp.backgroundColor = color
        })
    }


}

