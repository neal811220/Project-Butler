//
//  CreateNewProjectViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/2/3.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

enum ItemTitle: String {
    
    case projectName = "ProjectName"
    
    case projectLeader = "ProjectLeader"
    
    case date = "Date"
    
    case member = "Member"
    
    case workItem = "WorkItem"
}

class NewProjectViewController: UIViewController {

    lazy var newProjectTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.dataSource = self
        tv.rowHeight = UITableView.automaticDimension
        let topNib = UINib(nibName: "NewProjectTableViewCell", bundle: nil)
        let workItemNib = UINib(nibName: "WorkItemTableViewCell", bundle: nil)
        tv.register(topNib, forCellReuseIdentifier: "cell")
        tv.register(workItemNib, forCellReuseIdentifier: "workItemCell")
        tv.backgroundColor = UIColor(named: "NewProjectBackgroung")
        tv.layer.cornerRadius = 60
        tv.separatorStyle = .none
        return tv
    }()
    
    let backgroundView: UIView = {
        let bv = UIView()
        bv.layer.cornerRadius = 60
        bv.backgroundColor = UIColor(red: 129/255, green: 206/255, blue: 157/255, alpha: 1/0)
        bv.translatesAutoresizingMaskIntoConstraints = false
        return bv
    }()
    
    let projectNametextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Your Project Name "
        tf.isEnabled = true
        tf.textColor = UIColor.white
        tf.font = UIFont.boldSystemFont(ofSize: 17)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let leaderLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.white
        lbl.font = UIFont.boldSystemFont(ofSize: 17)
        lbl.text = "Hello"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        settingTableView()
    }
    
    func settingTableView() {
        
        view.addSubview(backgroundView)
        
        backgroundView.addSubview(newProjectTableView)
        
        
        NSLayoutConstraint.activate([
            
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 100),
            
            newProjectTableView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            newProjectTableView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor),
            newProjectTableView.rightAnchor.constraint(equalTo: backgroundView.rightAnchor),
            newProjectTableView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -100)
        ])
    }
    
    func settingLabel(text: String) -> UILabel{
        
        let leaderLabel: UILabel = {
            let lbl = UILabel()
            lbl.textColor = UIColor.white
            lbl.font = UIFont.boldSystemFont(ofSize: 17)
            lbl.text = text
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        return leaderLabel
    }
    
}

extension NewProjectViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return 3
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? NewProjectTableViewCell else { return UITableViewCell() }
            switch indexPath.row {

            case 0:

                cell.leftImageView?.image = UIImage.asset(.Icons_32px_ProjectName)

                cell.inputContentView.addSubview(projectNametextField)
                
                projectNametextField.frame = cell.inputContentView.frame
                
                cell.layoutIfNeeded()
            case 1:

                cell.leftImageView?.image = UIImage.asset(.Icons_32px_Leader)

                cell.inputContentView.addSubview(settingLabel(text: "Hello"))
                
                leaderLabel.frame = cell.inputContentView.frame

                cell.layoutIfNeeded()
            case 2:
                
                cell.leftImageView?.image = UIImage.asset(.Icons_32px_Calendar)
                
                cell.inputContentView.addSubview(settingLabel(text: "OKOK"))
                
                leaderLabel.frame = cell.inputContentView.frame

                cell.layoutIfNeeded()
            case 3:
                cell.leftImageView?.image = UIImage.asset(.Icons_32px_Member)
                
                cell.inputContentView.addSubview(settingLabel(text: "HEY"))
                
                leaderLabel.frame = cell.inputContentView.frame
                
                cell.layoutIfNeeded()
            default:
                break
            }
            return cell
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "workItemCell") as? WorkItemTableViewCell else { return UITableViewCell() }
            return cell
        }
        
    }
    
}

extension NewProjectViewController: UITableViewDelegate {
    
    
}
