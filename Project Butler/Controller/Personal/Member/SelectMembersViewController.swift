//
//  SelectMembersViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/2/12.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

protocol SelectMembersViewControllerDelegate: AnyObject {
    
    func passMember(_ selectMembersViewController: SelectMembersViewController, selectedMemberArray: [FriendDetail])
}

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
        
    var allfriends: [FriendDetail] = []
    
    var filterArray: [FriendDetail] = []
    
    var datas: [FriendDetail] = []
        
    var seletedArray: [FriendDetail] = []
    
    var passSelectMemeber: (([FriendDetail]) -> Void)?
    
    weak var delegate: SelectMembersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doneBarButton = UIBarButtonItem(title: "DONE", style: .done, target: self, action: #selector(didTapDoneBarButton))
        
        doneBarButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "AmericanTypewriter-Bold", size: 17)!], for: .normal)
        
        navigationItem.rightBarButtonItem = doneBarButton
        
        navigationItem.searchController = searchController
        
        navigationItem.title = LargeTitle.selectMemebers.rawValue
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = LargeTitle.selectMemebers.rawValue
        // Do any additional setup after loading the view.
        
        setupTableView()
        
        fetchFriends()
        
    }
    
    @objc func didTapDoneBarButton(sender: UIBarButtonItem) {
        
        if datas.count != 0 {
            
            seletedArray = datas.filter({ $0.isSeleted == true })
            
            passSelectMemeber?(seletedArray)
            
            delegate?.passMember(self, selectedMemberArray: seletedArray)
            
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
    
    func fetchFriends() {
                
        projectManager.friendArray = []
                
        PBProgressHUD.pbActivityView(viewController: tabBarController!)
        
        projectManager.fetchFriends { [weak self] (result) in
            
            guard let strongSelf = self else {
                
                return
            }
            
            switch result {
                
            case .success(let data):
                
                strongSelf.allfriends = data
                
                strongSelf.datas = strongSelf.allfriends
                
                strongSelf.tableView.reloadData()
                
            case .failure(let error):
                
                print(error)
                
                PBProgressHUD.showFailure(text: error.localizedDescription, viewController: strongSelf)
            }
            
            PBProgressHUD.dismiss()
        }
    }
    
    func filterContentForSearchText(searchText: String) {
        
        filterArray = allfriends.filter({ (member: Userable) -> Bool in
            
            if isSearchBarEmpty() {
                
                return false
                
            } else {
                
                datas = filterArray
                
                return true && member.userName.lowercased().contains(searchText.lowercased())

            }
        })
        
        if filterArray.count != 0 {
            
            datas = filterArray
            
        } else {
            
            datas = allfriends
        }
        
        tableView.reloadData()
    }
    
      func isSearchBarEmpty() -> Bool {
          
          return searchController.searchBar.text?.isEmpty ?? true
      }
      
      func isFiltering() -> Bool {
          
          return searchController.isActive && !isSearchBarEmpty()
      }

}

extension SelectMembersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectMemberCell", for: indexPath) as? SelectMemberTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        cell.userTitleLabel.text = datas[indexPath.row].userName
        
        cell.userEmailLabel.text = datas[indexPath.row].userEmail
        
        cell.rightImage.image = UIImage.asset(.Icons_64px_Check_Normal)
        
        cell.userImage.loadImage(datas[indexPath.row].userImageUrl, placeHolder: UIImage.asset(.Icons_128px_General))
        
        return cell
    }
    
}

extension SelectMembersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SelectMemberTableViewCell else { return }
        
        datas[indexPath.row].isSeleted = !datas[indexPath.row].isSeleted
        
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
        
        guard let text = searchController.searchBar.text else {
            return
        }
        
        filterContentForSearchText(searchText: text)
    }
    
}
