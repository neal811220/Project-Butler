//
//  MemberListViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/2/2.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class MemberListViewController: UIViewController {
    
    lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = PlaceHolder.friendPlaceHolder.rawValue
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.sizeToFit()
        search.searchBar.searchBarStyle = .prominent
        search.searchBar.delegate = self
        search.searchResultsUpdater = self
        return search
    }()
    
    lazy var memberTableView: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.rowHeight = UITableView.automaticDimension
        let nib = UINib(nibName: "FriendListTableViewCell", bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: "FriendListCell")
        tableview.separatorStyle = .none
        tableview.dataSource = self
        return tableview
    }()
    
    let userManager = UserManager.shared
    
    let activityView = UIActivityIndicatorView()
    
    var datas: [[Userable]] = []
    
    var friendsArray: [FriendDetail] = []
    
    var searchFriendArray: [FriendDetail] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.title = LargeTitle.memberList.rawValue
        
        self.navigationItem.searchController = searchController
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name("searchReload"), object: nil)
        
        settingTableView()
    }
    
    func settingTableView() {
        
        view.addSubview(memberTableView)
        
        NSLayoutConstraint.activate([
            memberTableView.topAnchor.constraint(equalTo: view.topAnchor),
            
            memberTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            
            memberTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            memberTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func reloadData() {
        
        datas.append(userManager.searchUserArray)
        
        memberTableView.reloadData()
        
        activityView.stopAnimating()
        
    }
    
}

extension MemberListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return datas[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell") as? FriendListTableViewCell else { return UITableViewCell() }
        
        cell.leftButton.isHidden = true
        
        cell.rightButton.isHidden = true
        
        cell.friendImage.loadImage(datas[indexPath.section][indexPath.row].userImageUrl, placeHolder: UIImage.asset(.Icons_128px_General))
        
        cell.friendTitle.text = datas[indexPath.section][indexPath.row].userName
        
        cell.friendEmail.text = datas[indexPath.section][indexPath.row].userEmail
        
        return cell
    }
    
}

extension MemberListViewController: UISearchBarDelegate {
    
}

extension MemberListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        datas = []
        
        memberTableView.reloadData()
        
        activityView.startAnimating()
        
        if searchController.searchBar.text == "" {
            
            userManager.searchAll { (result) in
                
                switch result {
                    
                case .success(()):
                    
                    print("SearchAll Success")
                
                case .failure(let error):
                    
                    print(error)
                }
                
                self.reloadData()
                
                self.userManager.clearAll()
            }
            
        } else {
            
            userManager.searchUser(text: searchController.searchBar.text!) { (result) in
                
                switch result {
                    
                case .success(let data):
                    
                    print("SearchUser Success")
                    print(data)
                    
                case .failure(let error):
                    
                    print(error)
                }
                
                self.reloadData()
                
                self.userManager.clearAll()
            }
        }
    }
    
}


