//
//  CreateWorkItemViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/2/12.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class CreateWorkItemViewController: UIViewController {

    lazy var tableview: UITableView = {
        let tv = UITableView()
//        tv.dataSource = self()
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
}
