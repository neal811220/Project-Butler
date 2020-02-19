//
//  ViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/1/22.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class PersonalViewController: UIViewController {
    
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
        
        tableView.register(processingNib, forCellReuseIdentifier: "ProcessingCell")
        
        tableView.register(completedNib, forCellReuseIdentifier: "CompletedCell")
        
        return tableView
    }()
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        
        sb.placeholder = PlaceHolder.projectPlaceHolder.rawValue
        
        sb.sizeToFit()
        
        sb.searchBarStyle = .minimal
        
        sb.translatesAutoresizingMaskIntoConstraints = false
        
        return sb
    }()
    
    let searchLeader: UIButton = {
        
        let searchImage = UIImage.asset(.Icons_32px_Leader)
        
        let selectedImage = UIImage.asset(.Icons_32px_SearhLeader_Selected)
        
        let bt = UIButton()
        
        bt.setImage(searchImage, for: .normal)
        
        bt.setImage(selectedImage, for: .selected)
        
        bt.translatesAutoresizingMaskIntoConstraints = false
        
        return bt
    }()
    
    var indicatorViewCenterXConstraint: NSLayoutConstraint?
    
    var checkButton = 0
    
    var searchBarStatus = false
    
    var searchBarStackViewHightConstraint: NSLayoutConstraint?
    
    var tableViewTopConstraint: NSLayoutConstraint?
    
    var userProjectDetail: [NewProject] = []
    
    var searchLeaderStaus = false
    
    var memberDetail: [[AuthInfo]] = []
    
    let activityView = UIActivityIndicatorView()
    
    let fetchUserSemaphone = DispatchSemaphore(value: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.title = LargeTitle.personalProject.rawValue
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.B2]
        
        setupActivityView()
        
        setupStackView()
        
        setupButtonStackView()
        
        setupSearchBar()
        
        setupTableView()
        
        fetchCurrentUserInfo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        titleStackView.isHidden = false
        
        filterArray()
        
        titleStackView.isHidden = false
        
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
        
        checkButton = sender.tag
        
        UIView.animate(withDuration: 0.5) {
            
            self.indicatorViewCenterXConstraint?.isActive = false
            
            self.indicatorViewCenterXConstraint = self.indicatorView.centerXAnchor.constraint(equalTo: sender.centerXAnchor)
            
            self.indicatorViewCenterXConstraint?.isActive = true
            
            self.view.layoutIfNeeded()
        }
        
        switch checkButton {
            
        case 0:
            
            fetchUserProcessingProjcet()
                    
        case 1:
            
            fetchUserCompletedProject()
                        
        default:
            
            break
        }
    }
    
    func fetchCurrentUserInfo() {
        
        UserManager.shared.getLoginUserInfo()
    }
    
    func clearAll() {
        
        userProjectDetail = []
        
        memberDetail = []
    }
    
    func setupActivityView() {
        
        view.addSubview(activityView)
        
        NSLayoutConstraint.activate([
            activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityView.heightAnchor.constraint(equalToConstant: view.frame.width / 10),
            activityView.widthAnchor.constraint(equalToConstant: view.frame.width / 10)
        ])
    }
    
    func fetchUserProcessingProjcet() {
        
        clearAll()
        
        tableView.reloadData()
        
        activityView.startAnimating()
        
        ProjectManager.shared.fetchUserProjects(isCompleted: false) { (result) in
            
            switch result {
                
            case .success(let data):
                
                self.userProjectDetail = data
                
                self.fetchMemberDetail()
                
            case .failure(let error):
                
                print(error)
                
                self.activityView.stopAnimating()
                
            }
            
        }
    }
    
    func fetchUserCompletedProject() {
        
        clearAll()
        
        tableView.reloadData()
        
        activityView.startAnimating()
        
        ProjectManager.shared.fetchUserProjects(isCompleted: true) { (result) in
            
            switch result {
                
            case .success(let data):
                
                self.userProjectDetail = data
                
                self.fetchMemberDetail()
                
            case .failure(let error):
                
                print(error)
                
                self.activityView.stopAnimating()
                
            }
            
        }
    }
    
    func fetchMemberDetail() {
        
        memberDetail = []
        
        activityView.startAnimating()
        
        ProjectManager.shared.fetchMemberDetail(projectMember: userProjectDetail) { (result) in
            
            switch result {
                
            case.success:
                
                self.memberDetail = ProjectManager.shared.members
                
                self.tableView.reloadData()
                
                ProjectManager.shared.clearAll()
                
            case .failure(let error):
                
                print(error)
            }
            
            self.activityView.stopAnimating()
            
        }
    }
    
    func filterArray() {
        
        guard let uid = UserDefaults.standard.value(forKey: "userID") as? String else {
            return
        }
                
        if searchLeader.isSelected {
            
            searchLeaderStaus = true
            
            userProjectDetail = userProjectDetail.filter({ return $0.projectLeaderID == uid })
            
            fetchMemberDetail()
            
        } else {
            
            searchLeaderStaus = false
            
            switch checkButton {
                
            case 0:
                
                fetchUserProcessingProjcet()
                
            case 1:
                
                fetchUserCompletedProject()
                
            default:
                break
            }
        }
        
    }
    
    @objc func filterLeaderProject(sender: UIButton) {
        
        searchLeader.isSelected.toggle()
        
        filterArray()
    }
    
    func setupSearchBar() {
        
        view.addSubview(searchbarStackView)
        
        searchbarStackView.addSubview(searchBar)
        
        searchbarStackView.addSubview(searchLeader)
        
        searchLeader.addTarget(self, action: #selector(filterLeaderProject), for: .touchUpInside)
        
        searchBarStackViewHightConstraint = searchbarStackView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            searchbarStackView.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 20),
            searchbarStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            searchbarStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            searchBarStackViewHightConstraint!
        ])
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: searchbarStackView.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: searchbarStackView.leftAnchor),
            searchBar.bottomAnchor.constraint(equalTo: searchbarStackView.bottomAnchor),
            searchBar.widthAnchor.constraint(equalToConstant: view.frame.width - 80)
        ])
        
        NSLayoutConstraint.activate([
            searchLeader.topAnchor.constraint(equalTo: searchbarStackView.topAnchor),
            searchLeader.rightAnchor.constraint(equalTo: searchbarStackView.rightAnchor),
            searchLeader.bottomAnchor.constraint(equalTo: searchbarStackView.bottomAnchor),
            searchLeader.leftAnchor.constraint(equalTo: searchBar.rightAnchor)
        ])
        
    }
    
    func setupTableView() {
        
        view.addSubview(tableView)
        tableViewTopConstraint = tableView.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 20)
        NSLayoutConstraint.activate([
            tableViewTopConstraint!,
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupStackView() {
        
        guard let navigationbar = navigationController?.navigationBar else { return }
        
        navigationController?.navigationBar.addSubview(titleStackView)
        
        titleStackView.addArrangedSubview(searchButton)
                
        searchButton.addTarget(self, action: #selector(didTouchSearchBtn), for: .touchUpInside)
                
        NSLayoutConstraint.activate([
            titleStackView.bottomAnchor.constraint(equalTo: navigationbar.bottomAnchor, constant: -10),
            titleStackView.rightAnchor.constraint(equalTo: navigationbar.rightAnchor, constant: -15),
            titleStackView.widthAnchor.constraint(equalToConstant: navigationbar.frame.width / 5),
            titleStackView.heightAnchor.constraint(equalToConstant: navigationbar.frame.height / 3)
        ])
    }
    
    func setupButtonStackView() {
        
        view.addSubview(topButtonStackView)
        
        view.addSubview(indicatorView)
        
        topButtonStackView.addArrangedSubview(processingButton)
        
        topButtonStackView.addArrangedSubview(completedButton)
        
        NSLayoutConstraint.activate([
            topButtonStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            topButtonStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            topButtonStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            topButtonStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        indicatorViewCenterXConstraint = indicatorView.centerXAnchor.constraint(equalTo: processingButton.centerXAnchor)
        
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: topButtonStackView.bottomAnchor, constant: 20),
            indicatorView.heightAnchor.constraint(equalToConstant: 3),
            indicatorView.widthAnchor.constraint(equalToConstant: (view.frame.width / 3) ),
            indicatorViewCenterXConstraint!
        ])
    }
    
}

extension PersonalViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userProjectDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch checkButton {
            
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProcessingCell") as? ProcessingTableViewCell else { return UITableViewCell() }
            
            if searchLeaderStaus {
                cell.leaderImage.isHidden = false
            } else {
                cell.leaderImage.isHidden = true
            }
            
            cell.members = memberDetail[indexPath.row]
            
            cell.titleLabel.text = userProjectDetail[indexPath.row].projectName
            
            cell.dateLabel.text = "\(userProjectDetail[indexPath.row].startDate) - \(userProjectDetail[indexPath.row].endDate)"
            
            cell.hourLabel.text = "\(userProjectDetail[indexPath.row].totalHours) Hour (\(userProjectDetail[indexPath.row].totalDays) Day)"
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedCell") as? CompletedTableViewCell else { return UITableViewCell() }
            
            if searchLeaderStaus {
                cell.leaderImage.isHidden = false
            } else {
                cell.leaderImage.isHidden = true
            }
            
            cell.members = memberDetail[indexPath.row]
            
            cell.titleLabel.text = userProjectDetail[indexPath.row].projectName
            
            cell.dateLabel.text = "\(userProjectDetail[indexPath.row].startDate) - \(userProjectDetail[indexPath.row].endDate)"
            
            cell.hourLabel.text = "\(userProjectDetail[indexPath.row].totalHours) Hour (\(userProjectDetail[indexPath.row].totalDays) Day)"
            
            cell.completionDateLabel.text = "202022020"
            
            cell.completionHourLable.text = "1111"
            
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension PersonalViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let workLogVC = UIStoryboard.personal.instantiateViewController(withIdentifier: "WorkLogVC") as? WorkLogViewController else {
            return
        }
        
        workLogVC.members = self.memberDetail[indexPath.row]
        
        workLogVC.projectDetail = self.userProjectDetail[indexPath.row]
                
        titleStackView.isHidden = true
        
        show(workLogVC, sender: nil)
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
        animator.startAnimation(afterDelay: 0.3 * Double(indexPath.item))
    }
    
}

