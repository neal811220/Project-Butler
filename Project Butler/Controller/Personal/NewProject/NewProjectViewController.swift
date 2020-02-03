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
        
        settingButtonInfo(button: projectLeaderfButton)
        
        settingButtonInfo(button: dateButton)
        
        settingButtonInfo(button: memberButton)
        
        settingButtonInfo(button: workItemButton)
        
        workItemTableView.dataSource = self
        
        workItemTableView.rowHeight = UITableView.automaticDimension
        
        cellBackgroundView.backgroundColor = UIColor.clear
        
        self.navigationItem.title = LargeTitle.newProject.rawValue

        self.navigationController?.navigationBar.prefersLargeTitles = true
                
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 23/255, green: 61/255, blue: 160/255, alpha: 1.0)]
        
        // Do any additional setup after loading the view.
    }
    
    func settingButtonInfo(button: UIButton) {
        
        button.layer.borderWidth = 1
        
        button.layer.borderColor = UIColor.darkGray.cgColor
        
        button.layer.cornerRadius = 15
    }
    
    @IBAction func pressedMember(_ sender: UIButton) {
        
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
