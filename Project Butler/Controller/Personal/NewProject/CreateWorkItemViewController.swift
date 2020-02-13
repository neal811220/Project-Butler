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
        let tableView = UITableView()
//        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}
