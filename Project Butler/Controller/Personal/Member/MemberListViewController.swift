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
    
    var filterFriendList = [FriendInfo]()
    
    let friends = FriendInfo.GetAllFriends()
    
    var shouldShowSearchResults = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.title = LargeTitle.memberList.rawValue

        self.navigationItem.searchController = searchController
        
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
    
    func filterContentForSearchText(searchText: String) {
           filterFriendList = friends.filter({ (friend: FriendInfo) -> Bool in
            
               //return true
               if isSearchBarEmpty() {
                   return false
               } else {
                   return true && friend.title.lowercased().contains(searchText.lowercased())
               }
           })
           memberTableView.reloadData()
       }


       func isSearchBarEmpty() -> Bool {
           //if text == nil(return true) else (return nil)
           return searchController.searchBar.text?.isEmpty ?? true
       }

       func isFiltering() -> Bool {
           //if scope == 1 or 2 return true
           return searchController.isActive && (!isSearchBarEmpty())
       }
    
}

extension MemberListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            
            return filterFriendList.count
            
        } else {
            let friendAll = friends.filter { (friend) -> Bool in
                return friend.email == ScopeButton.all.rawValue
            }
            return friendAll.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell") as? FriendListTableViewCell else { return UITableViewCell() }
        
        let currentFriend: FriendInfo

        if isFiltering() {
            
            currentFriend = filterFriendList[indexPath.row]
            
        } else {
            
            let friendAll = friends.filter { (friend) -> Bool in
                
                return friend.email == ScopeButton.all.rawValue
            }
            currentFriend = friendAll[indexPath.row]
            
        }
        
        cell.friendEmail.text = currentFriend.email
        
        cell.friendTitle.text = currentFriend.title
        
        return cell
    }
    
}

extension MemberListViewController: UISearchBarDelegate {
    
}

extension MemberListViewController: UISearchResultsUpdating {
    
    
    func updateSearchResults(for searchController: UISearchController) {
                
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
}


