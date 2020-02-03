//
//  FriendListViewController.swift
//  
//
//  Created by Neal on 2020/1/31.
//
import Foundation
import UIKit

class FriendListViewController: UIViewController {
    
    lazy var friendListTableView: UITableView = {
        
        let tableview = UITableView()
        
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        tableview.dataSource = self
        
        let nib = UINib(nibName: "FriendListTableViewCell", bundle: nil)
        
        tableview.register(nib, forCellReuseIdentifier: "FriendListCell")
        
        tableview.rowHeight = UITableView.automaticDimension
        
        tableview.separatorStyle = .none
        
        return tableview
    }()
    
    lazy var friendSearchController: UISearchController = {
        
        let bar  = UISearchController(searchResultsController: nil)
        
        bar.searchResultsUpdater = self
        
        bar.obscuresBackgroundDuringPresentation = false
        
        bar.searchBar.placeholder = UserManager.shared.friendSearcchPlaceHolder
        
        bar.searchBar.sizeToFit()
        
        bar.searchBar.scopeButtonTitles = UserManager.shared.scopeButtons
        
        bar.searchBar.searchBarStyle = .prominent
        
        bar.searchBar.delegate = self
        
        return bar
    }()
    
    //All count
    let friends = FriendInfo.GetAllFriends()
        
    //filterCount
    var filteredFriends = [FriendInfo]()
    
    var selectCenterConstraint: NSLayoutConstraint?
    
    var buttons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = LargeTitle.friendList.rawValue
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 23/255, green: 61/255, blue: 160/255, alpha: 1.0)]
        
        self.navigationItem.searchController = friendSearchController
        
        settingTableview()
    }

    func filterContentForSearchText(searchText: String, scope: String = ScopeButton.all.rawValue) {
        filteredFriends = friends.filter({ (country: FriendInfo) -> Bool in
            let doesCategoryMatch = (scope == ScopeButton.all.rawValue) || (country.email == scope)
            //return true
            if isSearchBarEmpty() {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && country.title.lowercased().contains(searchText.lowercased())
            }
        })
        friendListTableView.reloadData()
    }


    func isSearchBarEmpty() -> Bool {
        //if text == nil(return true) else (return nil)
        return friendSearchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        //if scope == 1 or 2 return true
        let searchBarScopeIsFiltering = friendSearchController.searchBar.selectedScopeButtonIndex != 0
        return friendSearchController.isActive && (!isSearchBarEmpty() || searchBarScopeIsFiltering)
    }
    
    func settingTableview() {
        
        view.addSubview(friendListTableView)
        
        NSLayoutConstraint.activate([
            friendListTableView.topAnchor.constraint(equalTo: view.topAnchor),
            
            friendListTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            
            friendListTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            friendListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FriendListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            if friendSearchController.searchBar.selectedScopeButtonIndex == 0 {
                
                let allfriend = filteredFriends.filter { (country) -> Bool in
                  
                    return country.email == ScopeButton.all.rawValue
                }
                 return allfriend.count
            } else {
                return filteredFriends.count
            }
           
        } else {
            if friendSearchController.searchBar.selectedScopeButtonIndex == 0 {
                
                let allfriend = friends.filter { (country) -> Bool in
                  
                    return country.email == ScopeButton.all.rawValue
                }
                
                return allfriend.count
                
            } else {
                return friends.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell", for: indexPath) as? FriendListTableViewCell else { return UITableViewCell() }
        
        let currentFriend: FriendInfo
        
        if  isFiltering() {
            if friendSearchController.searchBar.selectedScopeButtonIndex == 0 {
                
                let allfriend = filteredFriends.filter { (country) -> Bool in
                    
                    return country.email == ScopeButton.all.rawValue
                }
                currentFriend = allfriend[indexPath.row]
            } else {
                
                currentFriend = filteredFriends[indexPath.row]
                
            }
            
        } else {
            if friendSearchController.searchBar.selectedScopeButtonIndex == 0 {
                
                let allfriend = friends.filter { (country) -> Bool in
                    
                    return country.email == ScopeButton.all.rawValue
                }
                
                currentFriend = allfriend[indexPath.row]
            } else{
                
                currentFriend = friends[indexPath.row]
                
            }
            
        }
        cell.friendTitle.text = currentFriend.title
        
        cell.friendEmail.text = currentFriend.email
        
        switch currentFriend.email {
        
        case ScopeButton.all.rawValue:
            
            cell.rightButton.isHidden = true
        
        case ScopeButton.confirm.rawValue:
            
            cell.rightButton.isHidden = false
            
            cell.rightButton.setImage(UIImage.asset(.Icons_32px_Confirm), for: .normal)
        
        case ScopeButton.accept.rawValue:
           
            cell.rightButton.isHidden = false
            
            cell.rightButton.setImage(UIImage.asset(.Icons_32px_Accept), for: .normal)
            
        default:
            break
        }
        return cell
    }
    
}

extension FriendListViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searchController.searchBar.text!, scope: scope)
    }
}
