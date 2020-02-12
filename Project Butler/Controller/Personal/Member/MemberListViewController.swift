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
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.rowHeight = UITableView.automaticDimension
        let nib = UINib(nibName: "FriendListTableViewCell", bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: "FriendListCell")
        tableview.separatorStyle = .none
        tableview.dataSource = self
        tableview.delegate = self
        return tableview
    }()
    
    let userManager = UserManager.shared
    
    let activityView = UIActivityIndicatorView()
    
    var datas: [[Userable]] = []
    
    var friendsArray: [FriendDetail] = []
    
    var seletedLeader: [FriendDetail] = []
    
    var leaderIndex: IndexPath?
    
    var leaderName = ""
    
    var lastSelectedUid = ""
    
    var passLeaderName: ((String) -> Void)?
    
    var isCancel = false
    
    override func viewDidLoad() {
        
        let doneBarButton = UIBarButtonItem(title: "DONE", style: .done, target: self, action: #selector(didTapDoneBarButton))
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.title = LargeTitle.memberList.rawValue
        
        self.navigationItem.searchController = searchController
        
        self.navigationItem.rightBarButtonItem = doneBarButton
        
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name("searchReload"), object: nil)
        
        setupTableView()
        
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
    
    @objc func reloadData() {
        
        datas = []
        
        friendsArray = userManager.friendArray
        
        datas.append(userManager.friendArray)
        
        isCancel = false
        
        tableView.reloadData()
        
        activityView.stopAnimating()
        
    }
    
    @objc func didTapDoneBarButton(sender: UIBarButtonItem) {
        
        passLeaderName?(leaderName)
        
        navigationController?.popViewController(animated: true)
    }
    
}

extension MemberListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return datas[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            
            return "Member"
            
        } else {
            
            return "Friend"
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell") as?
            FriendListTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        
        cell.leftButton.isHidden = true
        
        cell.rightButton.isHidden = false
        
        cell.rightButton.setImage(UIImage.asset(.Icons_64px_Check_Normal), for: .normal)
        
        cell.rightButton.setImage(UIImage.asset(.Icos_62px_Check_Selected), for: .selected)
        
        cell.friendImage.loadImage(datas[indexPath.section][indexPath.row].userImageUrl, placeHolder: UIImage.asset(.Icons_128px_General))
        
        cell.friendTitle.text = datas[indexPath.section][indexPath.row].userName
        
        cell.friendEmail.text = datas[indexPath.section][indexPath.row].userEmail
        
        return cell
    }
    
}

extension MemberListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        leaderIndex = indexPath
        
    }
}

extension MemberListViewController: UISearchBarDelegate {
    
}

extension MemberListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        userManager.clearAll()
        
        activityView.startAnimating()
        
        if searchController.searchBar.text != "" {
            
            userManager.searchUser(text: searchController.searchBar.text!) { (result) in
                
                switch result {
                    
                case .success(let data):
                    
                    print(data)
                    
                case .failure(let error):
                    
                    print(error)
                }
                
                self.userManager.lastSearchText = ""
                
                self.userManager.clearAll()
                
                self.activityView.stopAnimating()
            }
            
        } else {
            
            guard isCancel != true else { return }
            
            self.userManager.lastSearchText = ""
            
            if friendsArray.count != 0 &&  seletedLeader.count != 0 {
                
                datas.remove(at: 0)
                isCancel = true
                tableView.reloadData()
            }
            
        }
    }
    
}

extension MemberListViewController: FriendListTableViewCellDelegate {
    
    func passIndexPath(_ friendListTableViewCell: FriendListTableViewCell) {
                
        if let selected = leaderIndex {
            
            if let cell = tableView.cellForRow(at: selected) as? FriendListTableViewCell {
                
                cell.rightButton.isSelected = false
            }
        }
        
        guard let indexPath = tableView.indexPath(for: friendListTableViewCell) else { return }
        
        leaderIndex = indexPath
        
        let uid = datas[indexPath.section][indexPath.row].userID

        userManager.getSeletedLeader(uid: uid) { (result) in
            
            switch result {
                
            case .success(let data):
                
                self.datas.append([data])
                
                self.seletedLeader.append(data)
                
                self.leaderName = data.userName
                
                print(data)
                
            case .failure(let error):
                
                print(error)
                
            }
        }
    }
    
}

