//
//  NewProjectViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/1/30.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class NewProjectViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var projectLeaderfButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    
    @IBOutlet weak var memberButton: UIButton!
    
    @IBOutlet weak var workItemButton: UIButton!
    
    @IBOutlet weak var workItemTableView: UITableView!
    
    let cellBackgroundView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.cornerRadius = 60
        
        setButtonInfo(button: projectLeaderfButton)
        
        setButtonInfo(button: dateButton)
        
        setButtonInfo(button: memberButton)
        
        setButtonInfo(button: workItemButton)
        
        workItemTableView.dataSource = self
        
        workItemTableView.rowHeight = UITableView.automaticDimension
        
        cellBackgroundView.backgroundColor = UIColor.clear
        
        // Do any additional setup after loading the view.
    }
    
    func setButtonInfo(button: UIButton) {
        
        button.layer.shadowOpacity = 0.5
        
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        button.layer.borderWidth = 1
        
        button.layer.borderColor = UIColor.darkGray.cgColor
        
        button.layer.cornerRadius = 10
    }
    
}

extension NewProjectViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "workItemCell", for: indexPath) as? WorkItemTableViewCell else { return UITableViewCell()}
        cell.selectedBackgroundView = cellBackgroundView
        return cell
    }
    
}
