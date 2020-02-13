//
//  CreateNewProjectViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/2/3.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class NewProjectViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.dataSource = self
        tv.delegate = self
        tv.rowHeight = UITableView.automaticDimension
        let topNib = UINib(nibName: "NewProjectTableViewCell", bundle: nil)
        let workItemNib = UINib(nibName: "WorkItemTableViewCell", bundle: nil)
        tv.register(topNib, forCellReuseIdentifier: "cell")
        tv.register(workItemNib, forCellReuseIdentifier: "workItemCell")
        tv.backgroundColor = UIColor.Gray1
        tv.layer.cornerRadius = 60
        tv.separatorStyle = .none
        return tv
    }()
    
    let backgroundView: UIView = {
        let bv = UIView()
        bv.layer.cornerRadius = 60
        bv.backgroundColor = UIColor.Gray1
        bv.translatesAutoresizingMaskIntoConstraints = false
        return bv
    }()
    
    let projectNametextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Your Project Name "
        tf.isEnabled = true
        tf.textColor = UIColor.Gray3
        tf.font = UIFont.boldSystemFont(ofSize: 17)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let leaderLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.Gray2
        lbl.font = UIFont.boldSystemFont(ofSize: 17)
        lbl.text = "Hello"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var leaderName = ""
    
    var membersArray: [FriendDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = LargeTitle.newProject.rawValue
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.B2]
        
        setupTableView()
    }
    
    func setupTableView() {
        
        view.addSubview(backgroundView)
        
        backgroundView.addSubview(tableView)
        
        
        NSLayoutConstraint.activate([
            
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 100),
            
            tableView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            tableView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: backgroundView.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -100)
        ])
    }
    
    func setupLabel(text: String) -> UILabel{
        
        let leaderLabel: UILabel = {
            let lbl = UILabel()
            lbl.textColor = UIColor.Gray3
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
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? NewProjectTableViewCell else { return UITableViewCell() }
            
            cell.leaderLabel.text = CurrentUserInfo.shared.userName
            
            cell.memeberInfo = membersArray
            
            
            cell.transitionToMemberVC = { [weak self] _ in
             
                guard let selectMemeberVC = UIStoryboard.personal.instantiateViewController(withIdentifier: "SelectMemeberVC") as? SelectMembersViewController else {
                    return
                }
                self?.show(selectMemeberVC, sender: nil)
                
                selectMemeberVC.passSelectMemeber = {
                    
                    self?.membersArray = $0
                    
                    tableView.reloadData()
                }
            }
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "workItemCell", for: indexPath) as? WorkItemTableViewCell else { return UITableViewCell() }
            return cell
        }
        
    }
    
}

extension NewProjectViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}

extension NewProjectViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProcessingCell", for: indexPath) as? ProcessingCollectionViewCell else { return UICollectionViewCell()}
        return cell
    }
    
}
