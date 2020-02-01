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
        
        tableview.delegate = self
        
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
        bar.searchBar.placeholder = "Type Email To Search Friend"
        bar.searchBar.sizeToFit()
        bar.searchBar.scopeButtonTitles = ["AllFrined", "Confirm", "Accept"]
        bar.searchBar.searchBarStyle = .prominent
        bar.searchBar.delegate = self
        
        return bar
    }()
    
    //All count
    let countries = Country.GetAllCountries()
    
    //filterCount
    var filteredCountries = [Country]()
    
    var selectCenterConstraint: NSLayoutConstraint?
    
    var buttons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "FriendList"
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 23/255, green: 61/255, blue: 160/255, alpha: 1.0)]
        
        self.navigationItem.searchController = friendSearchController
//        settingInfo()
        
        settingTableview()
    }

    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredCountries = countries.filter({ (country: Country) -> Bool in
            let doesCategoryMatch = (scope == "All") || (country.continent == scope)
            
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

extension FriendListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredCountries.count
        } else {
            let allfriend = countries.filter { (country) -> Bool in
                return country.continent == "AllFrined"
            }
            return allfriend.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell", for: indexPath) as? FriendListTableViewCell else { return UITableViewCell() }
        let currentCountry: Country
        
        if  isFiltering() {
            currentCountry = filteredCountries[indexPath.row]
        } else {
            let allfriend = countries.filter { (country) -> Bool in
                return country.continent == "AllFrined"
            }
            currentCountry = allfriend[indexPath.row]
        }
        cell.friendTitle.text = currentCountry.title
        cell.friendEmail.text = currentCountry.continent
        switch currentCountry.continent {
        case "AllFrined":
            cell.rightButton.isHidden = true
        case "Confirm":
            cell.rightButton.isHidden = false
            cell.rightButton.setImage(UIImage(named: "Icons_32px_Confirm"), for: .normal)
        case "Accept":
            cell.rightButton.isHidden = false
            cell.rightButton.setImage(UIImage(named: "Icons_32px_Accept"), for: .normal)
        default:
            break
        }
        return cell
    }
    
}

extension FriendListViewController: UISearchBarDelegate, UISearchResultsUpdating {

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
        print("New scope index is now \(selectedScope)")
        
    }

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]

        filterContentForSearchText(searchText: searchController.searchBar.text!, scope: scope)
    }
}

