//
//  FriendListViewController.swift
//  
//
//  Created by Neal on 2020/1/31.
//
import Foundation
import UIKit
import Firebase

class FriendListViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        
        let tableview = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
        
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        tableview.dataSource = self
        
        let nib = UINib(nibName: "FriendListTableViewCell", bundle: nil)
        
        tableview.register(nib, forCellReuseIdentifier: "FriendListCell")
        
        tableview.rowHeight = UITableView.automaticDimension
        
        tableview.separatorStyle = .none
        
        return tableview
    }()
    
    lazy var searchController: UISearchController = {
        
        let search  = UISearchController(searchResultsController: nil)
        
        search.searchResultsUpdater = self
        
        search.obscuresBackgroundDuringPresentation = false
        
        search.searchBar.placeholder = PlaceHolder.friendPlaceHolder.rawValue
        
        search.searchBar.sizeToFit()
        
        search.searchBar.scopeButtonTitles = UserManager.shared.scopeButtons
        
        search.searchBar.searchBarStyle = .prominent
        
        search.searchBar.delegate = self
        
        return search
    }()
    
    var activityView: UIActivityIndicatorView = {
        let ac = UIActivityIndicatorView()
        ac.translatesAutoresizingMaskIntoConstraints = false
        return ac
    }()
    
    //All count
    var searchUserArray: [AuthInfo] = []
    //filterCount
    var friendArray: [FriendDetail] = []
    
    var accepFriendArray: [FriendDetail] = []
    
    var confirmFriendArray: [FriendDetail] = []
    
    var datas: [[Userable]] = []
    
    var currentIndexPath: IndexPath?
    
    var currentSeletedIndex: Int {
        
        return searchController.searchBar.selectedScopeButtonIndex
    }
    
    var userTapStatus = false
    
    var userManager = UserManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = LargeTitle.friendList.rawValue
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.B2]
        
        navigationItem.searchController = searchController
        
        setupTableview()
        
        setupActivityView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name("searchReload"), object: nil)
        
        activityView.startAnimating()
        
        userManager.searchAll { (result) in
            
            switch result {
                
            case .success:
                
                self.reloadData()
                
            case .failure(let error):
                
                print(error)
                
            }
            
            self.activityView.stopAnimating()
            
        }
    }
    
    func setupActivityView() {
        
        view.addSubview(activityView)
        
        NSLayoutConstraint.activate([
            activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityView.heightAnchor.constraint(equalToConstant: view.frame.size.width / 10),
            activityView.widthAnchor.constraint(equalToConstant: view.frame.size.width / 10)
        ])
    }
    
    func setupTableview() {
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FriendListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return datas.count
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if currentSeletedIndex == 1 {
            
            switch section {
                
            case 0:
                
                return "Waiting Accept"
                
            case 1:
                
                return "Accept OR Refuse"
                
            default:
                
                return ""
            }
        } else if currentSeletedIndex == 0{
            
            return "Friend"
            
        } else {
            
            return "SearchUser"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return datas[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell", for: indexPath) as? FriendListTableViewCell else { return UITableViewCell() }
        
        cell.friendTitle.text = datas[indexPath.section][indexPath.row].userName
        
        cell.friendEmail.text = datas[indexPath.section][indexPath.row].userEmail
        
        cell.friendImage.loadImage(datas[indexPath.section][indexPath.row].userImageUrl, placeHolder: UIImage.asset(.Icons_128px_General))
        
        cell.rightButton.addTarget(self, action: #selector(tapButton(sender:)), for: .touchUpInside)
        
        cell.leftButton.addTarget(self, action: #selector(tapButton(sender:)), for: .touchUpInside)
        
        cell.delegate = self
        
        cell.rightButton.isSelected = false
        
        switch datas[indexPath.section][indexPath.row].userStatus(flag: userTapStatus) {
            
        case FriendStatus.friend.rawValue:
            cell.leftButton.isHidden = true
            cell.rightButton.isHidden = true
            
        case FriendStatus.accept.rawValue:
            cell.leftButton.isHidden = false
            cell.rightButton.isHidden = false
            cell.rightButton.setImage(UIImage.asset(.Icons_32px_Accept), for: .normal)
            cell.leftButton.setImage(UIImage.asset(.Icons_32px_Refuse), for: .normal)
            
        case FriendStatus.confirm.rawValue:
            cell.leftButton.isHidden = true
            cell.rightButton.isHidden = false
            cell.rightButton.setImage(UIImage.asset(.Icons_32px_Confirm), for: .normal)
        default:
            cell.leftButton.isHidden = true
            cell.rightButton.setImage(UIImage.asset(.Icons_32px_AddFriend_Normal), for: .normal)
            cell.rightButton.setImage(UIImage.asset(.Icons_32px_AddFriend_DidTap), for: .selected)
            cell.rightButton.isHidden = false
        }
        
        return cell
    }
    
    @objc func reloadData() {
        
        datas = []
        
        switch currentSeletedIndex {
            
        case 0:
            
            datas.append(userManager.friendArray)
                        
        case 1:
            
            datas.append(userManager.confirmArray)
            
            datas.append(userManager.acceptArray)
            
        case 2:
            
            datas.append(userManager.searchUserArray)
            
        default: break
        }
        
        tableView.reloadData()
        
        activityView.stopAnimating()
        
        userManager.isSearching = false
        
    }
    
    @objc func tapButton(sender: UIButton) {
        
        guard let indexPath = currentIndexPath else { return }
        
        if sender.tag == 0 {
            userTapStatus = false
        } else {
            userTapStatus = true
        }
        
        sender.isSelected = !sender.isSelected
        
        switch currentSeletedIndex {
            
        case 2:
            
            activityView.startAnimating()
            datas[indexPath.section][indexPath.row].tapAddButton()
            
        case 1:
            
            if sender.tag == 0 {
                activityView.startAnimating()
                datas[indexPath.section][indexPath.row].tapRefuseButton()
                
            } else {
                activityView.startAnimating()
                datas[indexPath.section][indexPath.row].tapAcceptButton()
            }
            
        default:
            
            break
        }
    }
    
}

extension FriendListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        currentIndexPath = indexPath
        print(indexPath)
    }
    
    
}

extension FriendListViewController: FriendListTableViewCellDelegate {
    
    func passIndexPath(_ friendListTableViewCell: FriendListTableViewCell) {
        
        guard let indexPath = tableView.indexPath(for: friendListTableViewCell) else { return }
        
        currentIndexPath = indexPath
    }
    
}

extension FriendListViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        datas = []
        
        tableView.reloadData()
        
        activityView.startAnimating()
        
        if searchController.searchBar.text == "" {
            
            UserManager.shared.searchAll { (result) in
                
                switch result {
                    
                case .success(let data):
                    
                    print(data)
                    
                    print("Success")
                    
                case .failure(let error):
                    
                    print(error)
                    
                }
                
                self.reloadData()
                
                self.activityView.stopAnimating()
            }
            
        } else {
            
            UserManager.shared.searchUser(text: searchController.searchBar.text!) { (result) in
                
                switch result {
                    
                case .success(let data):
                    
                    print(data)
                    
                case .failure(let error):
                    
                    print(error)
                    
                }
                
                self.reloadData()
                
                self.activityView.stopAnimating()
            }
        }
    }
}
