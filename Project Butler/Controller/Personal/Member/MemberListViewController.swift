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
        tableview.delegate = self
        return tableview
    }()
    
    let doneButton: UIBarButtonItem = {
        let bt = UIBarButtonItem()
        bt.tintColor = UIColor.B1
        return bt
    }()
    
    let userManager = UserManager.shared
    
    let activityView = UIActivityIndicatorView()
    
    var datas: [[Userable]] = []
    
    var friendsArray: [FriendDetail] = []
    
    var searchFriendArray: [FriendDetail] = []
    
    var selectedLeader: IndexPath?
    
    var leaderName = ""
    
    var passLeaderName: ((String) -> Void)?
    
   
    
    override func viewDidLoad() {
        
         let rightBarButton = UIBarButtonItem(title: "DONE", style: .done, target: self, action: #selector(didTapDoneButton))
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.title = LargeTitle.memberList.rawValue
        
        self.navigationItem.searchController = searchController
        
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
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
        
        datas.append(userManager.friendArray)
        
        memberTableView.reloadData()
        
        activityView.stopAnimating()
        
    }
    
    @objc func didTapDoneButton(sender: UIBarButtonItem) {
        
        passLeaderName?(leaderName)
        navigationController?.popViewController(animated: true)
    }
    
    func loadFriendData() {
        
        activityView.startAnimating()
        
        userManager.searchAll { (result) in
            
            switch result {
                
            case.success:
                
                self.memberTableView.reloadData()
                
            case .failure(let error):
                
                print(error)
            }
            
            self.activityView.stopAnimating()
        }
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell") as?
            FriendListTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        
        cell.leftButton.isHidden = true
        
        cell.rightButton.isHidden = false
        
        cell.rightButton.setImage(UIImage.asset(.Icons_64px_Check_Normal), for: .normal)
        
        cell.rightButton.setImage(UIImage.asset(.Icos_62px_Check_Seleted), for: .selected)
        
        cell.friendImage.loadImage(datas[indexPath.section][indexPath.row].userImageUrl, placeHolder: UIImage.asset(.Icons_128px_General))
        
        cell.friendTitle.text = datas[indexPath.section][indexPath.row].userName
        
        cell.friendEmail.text = datas[indexPath.section][indexPath.row].userEmail
        
        return cell
    }
    
}

extension MemberListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedLeader = indexPath
        
    }
}

extension MemberListViewController: UISearchBarDelegate {
    
}

extension MemberListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        datas = []
        
        memberTableView.reloadData()
        
        activityView.startAnimating()
        
        if searchController.searchBar.text != "" {
            
            userManager.searchUser(text: searchController.searchBar.text!) { (result) in
                
                switch result {
                    
                case .success(let data):
                    print(data)
                case .failure(let error):
                    print(error)
                }
                
                self.reloadData()
                
                UserManager.shared.clearAll()
                
                self.activityView.stopAnimating()
            }
        } else {
            
            self.reloadData()
        }
    }
    
}

extension MemberListViewController: FriendListTableViewCellDelegate {
    
    func passIndexPath(_ friendListTableViewCell: FriendListTableViewCell) {
        
        guard let indexPath = memberTableView.indexPath(for: friendListTableViewCell) else { return }
        
        let uid = datas[indexPath.section][indexPath.row].userID
        
        userManager.getSeletedLeader(uid: uid) { (result) in
            
            switch result {
                
            case .success(let data):
                
                print(data)
                
                self.leaderName = data.userName
                
            case .failure(let error):
                
                print(error)
                
            }
        }
    }
    
}

