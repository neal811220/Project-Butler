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
    
    var leaderName = ""
    
    var membersArray: [FriendDetail] = []
    
    var workItemArray: [String] = []
    
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
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 300),
            
            tableView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            tableView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: backgroundView.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -100)
        ])
    }
    
}

extension NewProjectViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 1
            
        } else {
            
            return workItemArray.count
        }
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
            
            cell.passInputText = {
                
                self.workItemArray.insert($0, at: 0)
                
                tableView.reloadData()
                
            }
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "workItemCell", for: indexPath) as? WorkItemTableViewCell else { return UITableViewCell() }
            
            cell.workItemLabel.text = workItemArray[indexPath.row]
            
            cell.removeItem = {
                
                guard let indexPath = tableView.indexPath(for: $0) else {
                    return
                }
                
                self.workItemArray.remove(at: indexPath.row)
                
                UIView.animate(withDuration: 0.3) {
                    
                }
                tableView.reloadData()
            }
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
