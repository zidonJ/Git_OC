//
//  DataTableViewCell.swift
//  iOS10SwiftCoreData
//
//  Created by zidonj on 2016/12/1.
//  Copyright © 2016年 zidon. All rights reserved.
//

import UIKit

class DataTableViewCell: UITableViewCell {

    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    
    var person:Person?=nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var calculatePert:Person{
        set{
            self.person=newValue
            self.updateUI(item: self.person!)
        }
        get{
            return self.person!
        }
    }
    
    func updateUI(item:Person)  {
        self.headImage.image=UIImage.init(data:item.headImage!)
        self.name.text=item.value(forKey: "name") as! String?
        self.age.text=(item.value(forKey: "age") as! NSNumber).stringValue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
