//
//  SelectMembersViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/2/12.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class SelectMembersViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.rowHeight = UITableView.automaticDimension
        let nib = UINib(nibName: "FriendListTableViewCell", bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: "FriendListCell")
        tableview.separatorStyle = .none
        tableview.dataSource = self
        tableview.delegate = self
        return tableview
    }()

    let searchController: UISearchController = {
        let search = UISearchController()
        
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

}

extension SelectMembersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}

extension SelectMembersViewController: UITableViewDelegate {
    
}
