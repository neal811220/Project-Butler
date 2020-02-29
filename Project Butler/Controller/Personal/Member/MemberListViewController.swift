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
        
        let nib = UINib(nibName: "SelectMemberTableViewCell", bundle: nil)
        
        tableview.register(nib, forCellReuseIdentifier: "SelectMemberCell")
        
        tableview.separatorStyle = .none
        
        tableview.dataSource = self
        
        tableview.delegate = self
        
        tableview.rowHeight = UITableView.automaticDimension
        
        return tableview
    }()
    
    var memberArray: [AuthInfo] = []
    
    var filterMemberArray: [AuthInfo] = []
    
    var projectDetail: ProjectDetail?
    
    let removeMeberGroup = DispatchGroup()
    
    let userManager = UserManager.shared
    
    let activityView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        
        let doneBarButton = UIBarButtonItem(title: "Invite", style: .done, target: self, action: #selector(didTapDoneBarButton))
        
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = LargeTitle.memberList.rawValue
        
        navigationItem.searchController = searchController
        
        navigationItem.rightBarButtonItem = doneBarButton
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        setupTableView()
        
    }
    
    deinit {
        print("MemberDeinit")
    }
    
    func filterContentForSearchText(searchText: String) {
        
        filterMemberArray = memberArray.filter({ (member: AuthInfo) -> Bool in
            
            if isSearchBarEmpty() {
                
                return false
                
            } else {
                
                return true && member.userName.lowercased().contains(searchText.lowercased())
                
            }
            
        })
        
        tableView.reloadData()
    }
    
    func isSearchBarEmpty() -> Bool{
        
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        
        return searchController.isActive && !isSearchBarEmpty()
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
    
    func removeMember(documentID: String, removeMemberID: String) {
        
        removeMeberGroup.enter()
        
        ProjectManager.shared.removeMember(documentID: documentID, memberID: removeMemberID) { [weak self] (result) in
            
            guard let strongSelf = self else {
                
                return
            }
            
            switch result {
                
            case .success:
                
                print("Success remove member")
                
            case .failure(let error):
                
                print(error)
                
                PBProgressHUD.showFailure(text: "\(error)", viewController: strongSelf)
            }
            strongSelf.removeMeberGroup.leave()
        }
    }
    
    func removeMemberID(documentID: String, removeMemberID: String) {
        
        removeMeberGroup.enter()
        
        ProjectManager.shared.removeMemberID(documentID: documentID, removeMemberID: removeMemberID) { [weak self] (result) in
            
            guard let strongSelf = self else {
                
                return
            }
            
            switch result {
                
            case .success:
                
                print("Success remove memberID")
                
            case .failure(let error):
                
                print(error)
                
                PBProgressHUD.showFailure(text: "\(error)", viewController: strongSelf)
            }
            
            strongSelf.removeMeberGroup.leave()
        }
    }
    
    
    
    @objc func didTapDoneBarButton(sender: UIBarButtonItem) {
        
        guard let seleteMemberVC = UIStoryboard.newProject.instantiateViewController(withIdentifier: "SelectMemeberVC") as? SelectMembersViewController else {
            return
        }
                
        show(seleteMemberVC, sender: nil)
    }
    
}

extension MemberListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            
            return filterMemberArray.count
            
        } else {
            
            return memberArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectMemberCell") as?
            SelectMemberTableViewCell else {
                
                return UITableViewCell()
        }
        
        if isFiltering() {
            
            cell.userTitleLabel.text = filterMemberArray[indexPath.row].userName
            
            cell.userEmailLabel.text = filterMemberArray[indexPath.row].userEmail
            
            cell.userImage.loadImage(filterMemberArray[indexPath.row].userImageUrl, placeHolder: UIImage.asset(.Icons_128px_General))
            
            return cell
            
        } else {
            
            cell.userTitleLabel.text = memberArray[indexPath.row].userName
            
            cell.userEmailLabel.text = memberArray[indexPath.row].userEmail
            
            cell.userImage.loadImage(memberArray[indexPath.row].userImageUrl, placeHolder: UIImage.asset(.Icons_128px_General))
            
            return cell
        }
    }
    
}

extension MemberListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            removeMember(documentID: projectDetail?.projectID ?? "", removeMemberID: memberArray[indexPath.row].userID)
            
            removeMemberID(documentID: projectDetail?.projectID ?? "", removeMemberID: memberArray[indexPath.row].userID)
            
            removeMeberGroup.notify(queue: DispatchQueue.main) { 
                
                self.memberArray.remove(at: indexPath.row)
                
                tableView.beginUpdates()
                
                tableView.deleteRows(at: [indexPath], with: .right)
                
                tableView.endUpdates()
                
                PBProgressHUD.showSuccess(text: "Remove Success", viewController: self)
                
            }
        }
    }
}

extension MemberListViewController: UISearchBarDelegate {
    
}

extension MemberListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else{
            return
        }
        
        filterContentForSearchText(searchText: text)
    }
    
}


