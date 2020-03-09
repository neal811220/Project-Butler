//
//  MemberListViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/2/2.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit
import Firebase

enum MemberButtonStatus: String {
    
    case invite = "Invite"
    
    case leaveGroup = "Leave"
}

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
    
    var memberArray: [Userable] = []
    
    var filterMemberArray: [Userable] = []
    
    var projectDetail: ProjectDetail?
    
    var isLeader = false
    
    var isCompletedProject = false
    
    let removeMeberGroup = DispatchGroup()
    
    let updateMemberGroup = DispatchGroup()
    
    let userManager = UserManager.shared
    
    let activityView = UIActivityIndicatorView()
    
    var barButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = LargeTitle.memberList.rawValue
        
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        setupBarButtonItem()
        
        setupTableView()
        
    }
    
    deinit {
        print("MemberDeinit")
    }
    
    func setupBarButtonItem() {
        
        if isCompletedProject {
            
            return
            
        } else {
            
            isLeader = projectDetail?.projectLeaderID == CurrentUserInfo.shared.userID
            
            if isLeader == true {
                
                barButton = UIBarButtonItem(title: MemberButtonStatus.invite.rawValue, style: .done, target: self, action: #selector(didTapDoneBarButton))
                barButton.tintColor = UIColor.B2
                
            } else {
                
                barButton = UIBarButtonItem(title: MemberButtonStatus.leaveGroup.rawValue, style: .done, target: self, action: #selector(leaveGroup))
               
                barButton.tintColor = UIColor.red
            }
            
            navigationItem.rightBarButtonItem = barButton
        }
        
    }
    
    func filterContentForSearchText(searchText: String) {
        
        filterMemberArray = memberArray.filter({ (member: Userable) -> Bool in
            
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
    
    func updateMember(documentID: String, updateMembers: [String]) {
                
        updateMemberGroup.enter()
        
        activityView.startAnimating()
        
        ProjectManager.shared.updateMember(documentID: documentID, memberID: updateMembers) { [weak self] (result) in

            guard let strongSelf = self else {
                
                return
            }
            
            switch result {
                
            case .success:
                
                print("update Members Success")
                
            case .failure(let error):
                
                print(error)
                
                PBProgressHUD.showFailure(text: "\(error)", viewController: strongSelf)
            }
            
            strongSelf.updateMemberGroup.leave()
        }
    }
    
    func updateMemberID(documentID: String, updateMembers: [String]) {
                
        updateMemberGroup.enter()
        
        ProjectManager.shared.updateMemberID(documentID: documentID, memberID: updateMembers) { [weak self] (result) in
            
            guard let strongSelf = self else {
                
                return
            }
            
            switch result {
                
            case .success:
                
                print("update Members Success")
                
            case .failure(let error):
                
                print(error)
                
                PBProgressHUD.showFailure(text: "\(error)", viewController: strongSelf)
            }
            
            strongSelf.activityView.stopAnimating()
            
            strongSelf.updateMemberGroup.leave()
        }
    }
    
    func updateNotify() {
        
        updateMemberGroup.notify(queue: DispatchQueue.main) { [weak self] in
        
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.tableView.reloadData()
            
        }
    }

    @objc func didTapDoneBarButton(sender: UIBarButtonItem) {
        
        guard let seleteMemberVC = UIStoryboard.newProject.instantiateViewController(withIdentifier: "SelectMemeberVC") as? SelectMembersViewController else {
            return
        }
        
        seleteMemberVC.delegate = self
        
        show(seleteMemberVC, sender: nil)
    }
    
    @objc func leaveGroup(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Are you sure you want to leave?", message: "Leave Group", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Leave", style: .destructive, handler: { [weak self] (alert) in
            
            guard let strongSelf = self else {
                
                return
            }
            
            guard let documentID = strongSelf.projectDetail?.projectID, let userID = CurrentUserInfo.shared.userID else {
                
                return
            }
            
            strongSelf.removeMember(documentID: documentID, removeMemberID: userID)
            
            strongSelf.removeMemberID(documentID: documentID, removeMemberID: userID)
            
            strongSelf.removeMeberGroup.notify(queue: DispatchQueue.main) {
                
                strongSelf.dismiss(animated: true, completion: {
                    
                    strongSelf.navigationController?.popViewController(animated: true)
                })
                
            }
            
        }))
        
        present(alertController, animated: true, completion: nil)
        
    }
    
}

extension MemberListViewController: SelectMembersViewControllerDelegate {
    
    func passMember(_ selectMembersViewController: SelectMembersViewController, selectedMemberArray: [FriendDetail]) {
                
        var filteredArray: [Userable] = []
        
        var users: [String] = []

        for member in selectedMemberArray {
            
            var isContained = false
            
            for index in 0 ..< self.memberArray.count {
            
                if member.userID == self.memberArray[index].userID {
                    
                    isContained = true
                    
                    break
                }
            }
            
            if !isContained {
                
                filteredArray.append(member)
            }
        }
        
        for user in filteredArray {
            
            users.append(user.userID)
        }
        
        updateMember(documentID: projectDetail?.projectID ?? "", updateMembers: users)
        
        updateMemberID(documentID: projectDetail?.projectID ?? "", updateMembers: users)
        
        updateNotify()
        
        self.memberArray.append(contentsOf: filteredArray)
        
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
        
        if isLeader && memberArray[indexPath.row].userID != projectDetail?.projectLeaderID {
            
            return true
            
        } else {
            
            return false
        }
        
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
