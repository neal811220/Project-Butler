//
//  ViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/1/22.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit
import Firebase

class PersonalViewController: UIViewController, UITextFieldDelegate {
    
    let searchButton: UIButton = {
        
        let searchImage = UIImage.asset(.Icons_32px_SearchProjectButton)
        
        let button = UIButton()
        
        button.setImage(searchImage, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let titleStackView: UIStackView = {
        
        let stackView = UIStackView()
        
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        
        stackView.distribution = UIStackView.Distribution.fillEqually
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let topButtonStackView: UIStackView = {
        
        let stackView = UIStackView()
        
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        
        stackView.distribution = UIStackView.Distribution.fillEqually
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let processingButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle("Processing", for: .normal)
        
        button.setTitleColor(UIColor.B1, for: .normal)
        
        button.titleLabel?.font = UIFont(name: "AmericanTypewriter-Bold", size: 25)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.isEnabled = true
        
        button.tag = 0
        
        button.addTarget(self, action: #selector(didTapStatusButton), for: .touchUpInside)
        
        return button
    }()
    
    let completedButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle("Completed", for: .normal)
        
        button.setTitleColor(UIColor.B1, for: .normal)
        
        button.titleLabel?.font = UIFont(name: "AmericanTypewriter-Bold", size: 25)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.isEnabled = true
        
        button.tag = 1
        
        button.addTarget(self, action: #selector(didTapStatusButton), for: .touchUpInside)
        
        return button
    }()
    
    let indicatorView: UIView = {
        
        let view = UIView()
        
        view.backgroundColor = UIColor.B2
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let searchbarStackView: UIStackView = {
        
        let stackView = UIStackView()
        
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let placeholderImage: UIImageView = {
        
        let image = UIImage.asset(.Icons_512px_ProjectPlaceholderImage)
        
        let imageView = UIImageView()
        
        imageView.image = image
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let placeholderLabel: UILabel = {
        
        let label = UILabel()
        
        label.textColor = UIColor.Gray3
        
        label.font = UIFont(name: "AmericanTypewriter-Bold", size: 20)
        
        label.text = "There are currently no projects. Please go to the new project page to add."
        
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView()
        
        let processingNib = UINib(nibName: "ProcessingTableViewCell", bundle: nil)
        
        let completedNib = UINib(nibName: "CompletedTableViewCell", bundle: nil)
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.dataSource = self
        
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        
        tableView.rowHeight = UITableView.automaticDimension
                
        tableView.register(processingNib, forCellReuseIdentifier: ProcessingTableViewCell.identifier)
                
        tableView.register(completedNib, forCellReuseIdentifier: CompletedTableViewCell.identifier)
        
        tableView.addRefreshHeader {
            
            self.refreshLoader()
        }
        
        return tableView
    }()
    
    lazy var searchProjectTexiField: UITextField = {
        
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.placeholder = PlaceHolder.projectPlaceHolder.rawValue
        
        textField.textColor = UIColor.darkGray
        
        textField.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 232/255, alpha: 1.0)
        
        textField.borderStyle = .roundedRect
        
        textField.font = UIFont(name: "AmericanTypewriter-Bold", size: 17)
        
        textField.layer.cornerRadius = 8
        
        textField.textAlignment = .center
        
        textField.delegate = self
                
        return textField
    }()
    
    let searchLeaderButton: UIButton = {
        
        let searchImage = UIImage.asset(.Icons_32px_Leader)
        
        let selectedImage = UIImage.asset(.Icons_32px_SearhLeader_Selected)
        
        let button = UIButton()
        
        button.setImage(searchImage, for: .normal)
        
        button.setImage(selectedImage, for: .selected)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var userProcessingArray: [ProjectDetail] = []
    
    var userCompletedArray: [ProjectDetail] = []
    
    var userProcessingFilterArray: [ProjectDetail] = []
    
    var userCompletedFilterArray: [ProjectDetail] = []
    
    var indicatorViewCenterXConstraint: NSLayoutConstraint?
    
    var checkButtonIndex = 0
        
    var searchBarStatus = false
    
    var searchBarStackViewHightConstraint: NSLayoutConstraint?
    
    var tableViewTopConstraint: NSLayoutConstraint?
    
    var searchLeaderStaus = false
    
    let refreshGroup = DispatchGroup()
    
    var cells: [PersonalTableViewCellModel] =
        [
        PersonalTableViewProcessingCellModel(),
        PersonalTableViewCompletedCellModel()
        ]
    
    var inputSearchText = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = LargeTitle.personalProject.rawValue
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.B2!]
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshProjectdata), name: NSNotification.Name(rawValue: "RefreshProjectData"), object: nil)
        
        navigationController?.navigationBar.tintColor = UIColor.B2
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        setupStackView()
        
        setupButtonStackView()
        
        setupSearchBar()
        
        setupTableView()
        
        fetchCurrentUserInfo()
        
        refreshLoader()
        
        setupPlaceholdeImage()
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        titleStackView.isHidden = false
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @objc func didTouchSearchBtn(sender: UIButton) {
        
        searchBarStatus = !searchBarStatus
        
        if searchBarStatus {
            
            UIView.animate(withDuration: 0.3) {
                
                self.tableViewTopConstraint?.isActive = false
                
                self.searchBarStackViewHightConstraint?.isActive = false
                
                self.searchBarStackViewHightConstraint = self.searchbarStackView.heightAnchor.constraint(equalToConstant: 30)
                
                self.tableViewTopConstraint = self.tableView.topAnchor.constraint(equalTo: self.searchbarStackView.bottomAnchor, constant: 20)
                
                self.tableViewTopConstraint?.isActive = true
                
                self.searchBarStackViewHightConstraint?.isActive = true
                
                self.view.layoutIfNeeded()
            }
            
        } else {
            
            UIView.animate(withDuration: 0.3) {
                
                self.tableViewTopConstraint?.isActive = false
                
                self.searchBarStackViewHightConstraint?.isActive = false
                
                self.searchBarStackViewHightConstraint = self.searchbarStackView.heightAnchor.constraint(equalToConstant: 0)
                
                self.tableViewTopConstraint = self.tableView.topAnchor.constraint(equalTo: self.indicatorView.bottomAnchor, constant: 20)
                
                self.tableViewTopConstraint?.isActive = true
                
                self.searchBarStackViewHightConstraint?.isActive = true
                
                self.view.layoutIfNeeded()
            }
            
        }
        
    }
    
    @objc func didTapStatusButton(sender: UIButton) {
        
        checkButtonIndex = sender.tag
        
        projectisEmpty()
        
        UIView.animate(withDuration: 0.5) {
            
            self.indicatorViewCenterXConstraint?.isActive = false
            
            self.indicatorViewCenterXConstraint = self.indicatorView.centerXAnchor.constraint(equalTo: sender.centerXAnchor)
            
            self.indicatorViewCenterXConstraint?.isActive = true
            
            self.view.layoutIfNeeded()
        }
        
        tableView.reloadData()
    }
    
    @objc func refreshProjectdata() {
        
        refreshLoader()
    }
    
    func projectisEmpty() {
        
        switch checkButtonIndex {
            
        case 0:
            
            if userProcessingFilterArray.count == 0 {
                
                placeholderImage.isHidden = false
                
                placeholderLabel.isHidden = false
                
            } else {
                
                placeholderImage.isHidden = true
                
                placeholderLabel.isHidden = true
            }
            
        case 1:
            
            if userCompletedFilterArray.count == 0 {
                
                placeholderImage.isHidden = false
                
                placeholderLabel.isHidden = false
                
            } else {
                
                placeholderImage.isHidden = true
                
                placeholderLabel.isHidden = true
            }
            
        default:
            
            break
        }
    }
    
    func clearAllArray() {
        
        userProcessingArray = []
        
        userCompletedArray = []
        
        userProcessingFilterArray = []
        
        userCompletedFilterArray = []
        
        ProjectManager.shared.completedProjectsArray = []
        
        ProjectManager.shared.processingProjectsArray = []
    }
    
    func refreshLoader() {
        
        if searchLeaderButton.isSelected {
                        
            searchLeaderButton.isSelected = false
        }
        
        clearAllArray()
        
        fetchUserProcessingProjcet()
        
        fetchUserCompletedProject()
        
        refreshGroup.notify(queue: DispatchQueue.main) { [weak self] in
            
            self?.projectisEmpty()
            
            self?.tableView.reloadData()
            
            self?.tableView.endHeaderRefreshing()
        }
    }
    
    func filterContentForSearchText(searchText: String) {
        
        switch checkButtonIndex {
            
        case 0:
            
            userProcessingFilterArray = userProcessingArray.filter({ (project: ProjectDetail) -> Bool in
                
                if isSearchTextEmpty() {
                    
                    userProcessingFilterArray = userProcessingArray
                    
                    return false
                    
                } else {
                    
                    return true && project.projectName.lowercased().contains(searchText.lowercased())
                }
            })
            
        case 1:
            
            userCompletedFilterArray = userCompletedArray.filter({ (project: ProjectDetail) -> Bool in
                
                if isSearchTextEmpty() {
                    
                    userCompletedFilterArray = userCompletedArray
                    
                    return false
                    
                } else {
                    
                    return true && project.projectName.lowercased().contains(searchText.lowercased())
                    
                }
            })
            
        default:
            
            break
        }
        
        tableView.reloadData()
    }
    
    func isSearchTextEmpty() -> Bool {
        
        return inputSearchText == ""
    }
    
    func isFiltering() -> Bool {
        
        return !isSearchTextEmpty()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let previousText: NSString = textField.text! as NSString
        
        let updatedText = previousText.replacingCharacters(in: range, with: string)
        
        print("updatedText > ", updatedText)
        
        inputSearchText = updatedText
        
        filterContentForSearchText(searchText: updatedText)
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard searchProjectTexiField.text != "" else {
            
            switch checkButtonIndex {
                
            case 0:
                
                userProcessingFilterArray = userProcessingArray
                
            case 1:
                
                userCompletedFilterArray = userCompletedArray
                
            default:
                
                break
            }
            
            return tableView.reloadData()
        }
    }
    
    func fetchCurrentUserInfo() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        PBProgressHUD.pbActivityView(viewController: tabBarController!)
        
        CurrentUserInfo.shared.getLoginUserInfo(uid: uid) { [weak self] (result) in

            guard let strongSelf = self else {
                
                return
            }
            
            switch result {
                
            case .success:
                
                print("Success Get User Info")
                
                PBProgressHUD.dismiss()
                
            case .failure(let error):
                
                print(error)
                
                PBProgressHUD.showFailure(text: error.localizedDescription, viewController: strongSelf)
            }
            
            PBProgressHUD.dismiss()
        }
    }

    func fetchUserProcessingProjcet() {
        
        PBProgressHUD.pbActivityView(viewController: self)
        
        refreshGroup.enter()
        
        ProjectManager.shared.fetchUserProcessingProjects { [weak self] (result) in
            
            guard let strongSelf = self else {
                
                return
            }
            
            switch result {
                
            case .success(let data):
                
                strongSelf.userProcessingArray = data
                
                strongSelf.userProcessingArray = strongSelf.userProcessingArray.sorted(by: { $0.startDate > $1.startDate })
                
                strongSelf.userProcessingFilterArray = strongSelf.userProcessingArray
                
            case .failure(let error):
                
                print(error)
                
                PBProgressHUD.showFailure(text: error.localizedDescription, viewController: strongSelf)
                
            }
            
            PBProgressHUD.dismiss()
            
            strongSelf.refreshGroup.leave()
        }
    }
    
    func fetchUserCompletedProject() {
        
        PBProgressHUD.pbActivityView(viewController: self)
        
        refreshGroup.enter()
        
        ProjectManager.shared.fetchUserCompletedProjects { [weak self] (result) in
            
            guard let strongSelf = self else {
                
                return
            }
            
            switch result {
                
            case .success(let data):
                
                strongSelf.userCompletedArray = data
                
                strongSelf.userCompletedArray = strongSelf.userCompletedArray.sorted(by: { $0.startDate > $1.startDate })
                
                strongSelf.userCompletedFilterArray = strongSelf.userCompletedArray
                
            case .failure(let error):
                
                print(error)
                
                PBProgressHUD.showFailure(text: error.localizedDescription, viewController: strongSelf)
            }
            
            PBProgressHUD.dismiss()
            
            strongSelf.refreshGroup.leave()
        }
    }
    
    func fetchMemberDetail(documentRef: [DocumentReference], completion: @escaping (Result<[AuthInfo], Error>) -> Void) {
        
        PBProgressHUD.pbActivityView(viewController: tabBarController!)
        
        ProjectManager.shared.projectMembers = []
        
        ProjectManager.shared.fetchMemberDetail(projectMember: documentRef) { (result) in
 
            switch result {
                
            case.success(let data):
                
                completion(.success(data))
                
            case .failure(let error):
                
                print(error)
                
                completion(.failure(error))
                
            }
            
            PBProgressHUD.dismiss()
        }
    }
    
    @objc func filterLeaderProject(sender: UIButton) {
        
        searchLeaderButton.isSelected.toggle()
        
        switch checkButtonIndex {
            
        case 0:
            
            if searchLeaderButton.isSelected == true {
                
                userProcessingFilterArray = userProcessingFilterArray.filter({ return $0.projectLeaderID == CurrentUserInfo.shared.userID})
                
            } else {
                
                userProcessingFilterArray = userProcessingArray
            }
            
        case 1:
            
            if searchLeaderButton.isSelected == true {
                
                userCompletedFilterArray = userCompletedFilterArray.filter({
                    
                    return $0.projectLeaderID == CurrentUserInfo.shared.userID
                })
                
            } else {
                
                userCompletedFilterArray = userCompletedArray
                
            }
            
        default:
            
            break
        }
        
        tableView.reloadData()
        
    }
    
    func setupPlaceholdeImage() {
                
        view.addSubview(placeholderImage)
        
        view.addSubview(placeholderLabel)
        
        placeholderImage.anchor(
            
            centerX: view.centerXAnchor,
                                
            centerY: view.centerYAnchor,
                                
            width: view.frame.width / 4,
                                
            height: view.frame.width / 4
                               
        )
        
        placeholderLabel.anchor(
            
            top: placeholderImage.bottomAnchor,
                               
            centerX: view.centerXAnchor,
                                
            paddingTop: 5,
            
            paddingCenterX: 0,
            
            width: view.frame.width / 3 * 2,
            
            height: view.frame.width / 3
                                
        )
    }
    
    func setupSearchBar() {
        
        view.addSubview(searchbarStackView)
        
        searchbarStackView.addSubview(searchProjectTexiField)
        
        searchbarStackView.addSubview(searchLeaderButton)
        
        searchLeaderButton.addTarget(self, action: #selector(filterLeaderProject), for: .touchUpInside)
        
        searchbarStackView.anchor(
            
            top: indicatorView.bottomAnchor,
                                 
            left: view.leftAnchor,
            
            right: view.rightAnchor,
            
            paddingTop: 20,
            
            paddingLeft: 20,
            
            paddingRight: 20
            
        )
        
        searchBarStackViewHightConstraint = searchbarStackView.heightAnchor.constraint(equalToConstant: 0)
        
        searchBarStackViewHightConstraint?.isActive = true
        
        searchProjectTexiField.anchor(
            
            top: searchbarStackView.topAnchor,
            
            left: searchbarStackView.leftAnchor,
            
            bottom: searchbarStackView.bottomAnchor,
            
            width: view.frame.width - 80
        )
        
        searchLeaderButton.anchor(
            
            top: searchbarStackView.topAnchor,
            
            left: searchProjectTexiField.rightAnchor,
            
            bottom: searchbarStackView.bottomAnchor,
            
            right: searchbarStackView.rightAnchor
        )
    }
    
    func setupTableView() {
        
        view.addSubview(tableView)
        
        tableViewTopConstraint = tableView.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 20)
        
        tableViewTopConstraint?.isActive = true
        
        tableView.anchor(
            
            left: view.leftAnchor,
            
            bottom: view.bottomAnchor,
            
            right: view.rightAnchor,
            
            paddingLeft: 10,
            
            paddingRight: 10
        )
    }
    
    func setupStackView() {
        
        guard let navigationbar = navigationController?.navigationBar else {
            
            return
        }
        
        navigationController?.navigationBar.addSubview(titleStackView)
        
        titleStackView.addArrangedSubview(searchButton)
        
        searchButton.addTarget(self, action: #selector(didTouchSearchBtn), for: .touchUpInside)
        
        titleStackView.anchor(
            
            bottom: navigationbar.bottomAnchor,
            
            right: navigationbar.rightAnchor,
            
            paddingBottom: 10,
            
            paddingRight: 15,
            
            width: navigationbar.frame.width / 5,
            
            height: navigationbar.frame.height / 3
        )
    }
    
    func setupButtonStackView() {
        
        view.addSubview(topButtonStackView)
        
        view.addSubview(indicatorView)
        
        topButtonStackView.addArrangedSubview(processingButton)
        
        topButtonStackView.addArrangedSubview(completedButton)
        
        topButtonStackView.anchor(
            
            top: view.safeAreaLayoutGuide.topAnchor,
            
            left: view.leftAnchor,
            
            right: view.rightAnchor,
            
            paddingTop: 20,
            
            paddingLeft: 20 ,
            
            paddingRight: 20,
            
            height: 40
        )
        
        indicatorViewCenterXConstraint = indicatorView.centerXAnchor.constraint(equalTo: processingButton.centerXAnchor)
        
        indicatorViewCenterXConstraint?.isActive = true
        
        indicatorView.anchor(
            
            top: topButtonStackView.bottomAnchor,
            
            paddingTop: 20,
            
            width: view.frame.width / 3,
            
            height: 3
        )
    }
    
}

extension PersonalViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch checkButtonIndex {
            
        case 0:
            
            return userProcessingFilterArray.count
            
        case 1:
            
            return userCompletedFilterArray.count
            
        default:
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cells[checkButtonIndex].identifier, for: indexPath)

        var filterArray: [ProjectDetail] = []
        
        switch checkButtonIndex {
            
        case 0:
            
            filterArray = userProcessingFilterArray
            
        case 1:
            
            filterArray = userCompletedFilterArray
            
        default:
            
            break
        }
        
        cells[checkButtonIndex].setCell(tableViewCell: cell, button: searchLeaderButton, projectDetailData: filterArray, row: indexPath.row, passData: { [weak self] in

            guard let strongSelf = self else {
                return
            }

            guard let memberVC = UIStoryboard.personal.instantiateViewController(withIdentifier: "MemberVC") as? MemberListViewController else {
                return
            }

            PBProgressHUD.pbActivityView(viewController: strongSelf.tabBarController!)

            strongSelf.fetchMemberDetail(documentRef: filterArray[indexPath.row].projectMember) { (result) in

                switch result {

                case .success(let data):

                    memberVC.memberArray = data

                case .failure(let error):

                    print(error)
                }
                
                PBProgressHUD.dismiss()

                memberVC.projectDetail = filterArray[indexPath.row]

                strongSelf.titleStackView.isHidden = true

                strongSelf.show(memberVC, sender: nil)
            }

        })

        return cell

    }
}

extension PersonalViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let workLogVC = UIStoryboard.personal.instantiateViewController(withIdentifier: "WorkLogVC") as? WorkLogViewController else {
            return
        }

        switch checkButtonIndex {
            
        case 0:
            
            workLogVC.projectDetail = userProcessingFilterArray[indexPath.row]
            
            PBProgressHUD.pbActivityView(viewController: tabBarController!)
            
            fetchMemberDetail(documentRef: userProcessingFilterArray[indexPath.row].projectMember) { [weak self] (result) in
                
                guard let strongSelf = self else {
                    
                    return
                }
                
                switch result {
                    
                case .success(let data):
                    
                    workLogVC.members = data
                    
                case .failure(let error):
                    
                    print(error)
                }
                
                PBProgressHUD.dismiss()
                
                strongSelf.titleStackView.isHidden = true
                
                strongSelf.show(workLogVC, sender: nil)
            }
            
        case 1:
            
            workLogVC.projectDetail = userCompletedFilterArray[indexPath.row]
            
            PBProgressHUD.pbActivityView(viewController: tabBarController!)
            
            fetchMemberDetail(documentRef: userCompletedFilterArray[indexPath.row].projectMember) { [weak self] (result) in
                
                guard let strongSelf = self else {
                    
                    return
                }
                
                switch result {
                    
                case .success(let data):
                    
                    workLogVC.members = data
                    
                case .failure(let error):
                    
                    print(error)
                }
                
                PBProgressHUD.dismiss()
                
                strongSelf.titleStackView.isHidden = true
                
                strongSelf.show(workLogVC, sender: nil)
            }
            
        default:
            
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let spring = UISpringTimingParameters(dampingRatio: 0.5, initialVelocity: CGVector(dx: 1.0, dy: 0.2))
        
        let animator = UIViewPropertyAnimator(duration: 1.0, timingParameters: spring)
        
        cell.alpha = 0
        
        cell.transform = CGAffineTransform(translationX: 0, y: 100 * 0.6)
        
        animator.addAnimations {
            
            cell.alpha = 1
            
            cell.transform = .identity
            
            self.tableView.layoutIfNeeded()
        }
        
        animator.startAnimation(afterDelay: 0.1 * Double(indexPath.item))
    }
}
