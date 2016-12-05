//
//  LookDataViewController.swift
//  iOS10SwiftCoreData
//
//  Created by zidonj on 2016/12/1.
//  Copyright © 2016年 zidon. All rights reserved.
//

import UIKit
import CoreData

class LookDataViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let dataRecord:ZDCoreDataStack=ZDCoreDataStack.init(dataName: "Person", storeType: NSSQLiteStoreType)
    var dataSource:Array<Any>?=nil
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let fetchData:Array<Any>=dataRecord.fetchData(enity: "Person", ascendBy: "age", ascending: false)!
        dataSource=fetchData
        //print(fetchData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.rowHeight=80;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataSource?.count)!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId="dataCell"
        var cell:DataTableViewCell?=tableView.dequeueReusableCell(withIdentifier: cellId) as? DataTableViewCell
        if cell == nil {
            cell=Bundle.main.loadNibNamed("DataTableViewCell", owner: self, options: nil)?.last as? DataTableViewCell
        }
        cell?.calculatePert=(dataSource?[indexPath.row] as? Person)!
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func back(_ sender: UIButton) {
        self .dismiss(animated: true, completion: nil)
    }
}
