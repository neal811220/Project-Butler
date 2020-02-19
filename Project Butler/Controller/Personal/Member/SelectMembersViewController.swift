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
        
        let tableview = UITableView()
        
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        tableview.rowHeight = UITableView.automaticDimension
        
        let nib = UINib(nibName: "SelectMemberTableViewCell", bundle: nil)
        
        tableview.register(nib, forCellReuseIdentifier: "SelectMemberCell")
        
        tableview.separatorStyle = .none
        
        tableview.dataSource = self
        
        tableview.delegate = self
        
        tableview.rowHeight = UITableView.automaticDimension
        
        return tableview
    }()

    lazy var searchController: UISearchController = {
        
        let search  = UISearchController(searchResultsController: nil)
        
        search.searchResultsUpdater = self
        
        search.obscuresBackgroundDuringPresentation = false
        
        search.searchBar.placeholder = PlaceHolder.friendPlaceHolder.rawValue
        
        search.searchBar.sizeToFit()
                
        search.searchBar.searchBarStyle = .prominent
        
        search.searchBar.delegate = self
        
        return search
    }()
    
    var projectManager = ProjectManager.shared
    
    let activityView = UIActivityIndicatorView()
    
    var allfriends: [FriendDetail] = []
    
    var datas: [FriendDetail] = []
    
    var seletedArray: [FriendDetail] = []
    
    var passSelectMemeber: (([FriendDetail]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doneBarButton = UIBarButtonItem(title: "DONE", style: .done, target: self, action: #selector(didTapDoneBarButton))
        
        navigationItem.rightBarButtonItem = doneBarButton
        
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = LargeTitle.selectMemebers.rawValue
        // Do any additional setup after loading the view.
        
        setupTableView()
        
        fetchFriends()
        
        setupActivity()
    }
    
    @objc func didTapDoneBarButton(sender: UIBarButtonItem) {
        
        if allfriends.count != 0 {
            
            seletedArray = allfriends.filter({ $0.isSeleted == true })
            
            passSelectMemeber?(seletedArray)
            
            print(seletedArray)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func setupTableView() {
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupActivity() {
        
        view.addSubview(activityView)
        
        activityView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityView.heightAnchor.constraint(equalToConstant: view.frame.size.width / 10),
            activityView.widthAnchor.constraint(equalToConstant: view.frame.size.width / 10)
        ])
    }
    
    func fetchFriends() {
        
        allfriends = []
        
        projectManager.friendArray = []
        
        projectManager.filterArray = []
        
        activityView.startAnimating()
        
        projectManager.fetchFriends { (result) in
            
            switch result {
                
            case .success(let data):
                
                self.allfriends = data
                
                self.tableView.reloadData()
                
            case .failure(let error):
                
                print(error)
            }
            self.projectManager.isSearching = false
            
            self.activityView.stopAnimating()
        }
    }
    
    func filterFriends(text: String) {
        
        allfriends = []
        
        projectManager.filterArray = []
        
        projectManager.friendArray = []
        
        activityView.startAnimating()
        
        projectManager.filterSearch(text: text) { (result) in
            
            switch result {
                
            case .success(let data):
                
                self.allfriends = data
                
                self.tableView.reloadData()
                
            case .failure(let error):
                
                print(error)
                
            }
            
            self.projectManager.lastSearchText = ""
            
            self.activityView.stopAnimating()
        }
    }

}

extension SelectMembersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allfriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectMemberCell", for: indexPath) as? SelectMemberTableViewCell else { return UITableViewCell() }
        
        cell.userTitleLabel.text = allfriends[indexPath.row].userName
        
        cell.userEmailLabel.text = allfriends[indexPath.row].userEmail
        
        cell.rightImage.image = UIImage.asset(.Icons_64px_Check_Normal)
        
        cell.userImage.loadImage(allfriends[indexPath.row].userImageUrl, placeHolder: UIImage.asset(.Icons_128px_General))
        
        return cell
    }
    
}

extension SelectMembersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SelectMemberTableViewCell else { return }
        
        allfriends[indexPath.row].isSeleted = !allfriends[indexPath.row].isSeleted
        
        switch cell.select {
            
        case false:
            
            cell.rightImage.image = UIImage.asset(.Icos_62px_Check_Selected)
            
            cell.select = true
            
        case true:

            cell.rightImage.image = UIImage.asset(.Icons_64px_Check_Normal)
            
            cell.select = false
            
        default:
            
            break
        }
    }
}

extension SelectMembersViewController: UISearchBarDelegate {
    
}

extension SelectMembersViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text == "" {
            
            fetchFriends()
            
        } else {
            
            filterFriends(text: searchController.searchBar.text!)
            
        }
    }
    
    
}
