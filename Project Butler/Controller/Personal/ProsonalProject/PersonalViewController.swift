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
        let bt = UIButton()
        bt.setImage(searchImage, for: .normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        return bt
    }()
    
    let addButton: UIButton = {
        let addrProjectImage = UIImage.asset(.Icons_32px_AddProjectButton)
        let bt = UIButton()
        bt.setImage(addrProjectImage, for: .normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.isEnabled = true
        return bt
    }()
    
    let titleStackView: UIStackView = {
        let st = UIStackView()
        st.axis = NSLayoutConstraint.Axis.horizontal
        st.distribution = UIStackView.Distribution.fillEqually
        st.translatesAutoresizingMaskIntoConstraints = false
        return st
    }()
    
    let topButtonStackView: UIStackView = {
        let st = UIStackView()
        st.axis = NSLayoutConstraint.Axis.horizontal
        st.distribution = UIStackView.Distribution.fillEqually
        st.translatesAutoresizingMaskIntoConstraints = false
        return st
    }()
    
    let processingButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("Processing", for: .normal)
        bt.setTitleColor(UIColor.B1, for: .normal)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.isEnabled = true
        bt.tag = 0
        bt.addTarget(self, action: #selector(didTapStatusButton), for: .touchUpInside)
        return bt
    }()
    
    let completedButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("Completed", for: .normal)
        bt.setTitleColor(UIColor.B1, for: .normal)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.isEnabled = true
        bt.tag = 1
        bt.addTarget(self, action: #selector(didTapStatusButton), for: .touchUpInside)
        return bt
    }()
    
    let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.B2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchbarStackView: UIStackView = {
        let st = UIStackView()
        st.axis = NSLayoutConstraint.Axis.horizontal
        st.translatesAutoresizingMaskIntoConstraints = false
        return st
    }()
    
   lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.rowHeight = UITableView.automaticDimension
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.dataSource = self
        tb.delegate = self
        tb.separatorStyle = .none
        let processingNib = UINib(nibName: "ProcessingTableViewCell", bundle: nil)
        let completedNib = UINib(nibName: "CompletedTableViewCell", bundle: nil)
        tb.register(processingNib, forCellReuseIdentifier: "ProcessingCell")
        tb.register(completedNib, forCellReuseIdentifier: "CompletedCell")
        return tb
    }()
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        
        sb.placeholder = PlaceHolder.projectPlaceHolder.rawValue
        
        sb.sizeToFit()

        sb.searchBarStyle = .minimal
        
        sb.translatesAutoresizingMaskIntoConstraints = false
        
        return sb
    }()
    
    let searchImage: UIButton = {
        let searchImage = UIImage.asset(.Icons_32px_Leader)
        let bt = UIButton()
        bt.setImage(searchImage, for: .normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        return bt
    }()
    
    var indicatorViewCenterXConstraint: NSLayoutConstraint?
    
    var checkButton = 0
    
    var searchBarStatus = false
    
    var searchBarStackViewHightConstraint: NSLayoutConstraint?
    
    var tableViewTopConstraint: NSLayoutConstraint?
    
    let projectBackground: [ProjectColor] = [.BCB1, .BCB2, .BCB3, .BCG1, .BCG2, .BCB3, .BCO1, .BCR1, .BCR2]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.title = LargeTitle.personalProject.rawValue
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.B2]
        
        setupStackView()
        
        setupButtonStackView()
        
        setupSearchBar()
        
        setupTableView()
        
        fetchCurrentUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
    
    @objc func didTouchAddBtn(sender: UIButton) {
        
        guard let newProjectVC = UIStoryboard.personal.instantiateViewController(withIdentifier: "NewProjectVC") as? NewProjectViewController else { return }
        titleStackView.isHidden = true
        show(newProjectVC, sender: nil)
    }
    
    @objc func didTapStatusButton(sender: UIButton) {
        
        checkButton = sender.tag
        
        UIView.animate(withDuration: 0.5) {
            
            self.indicatorViewCenterXConstraint?.isActive = false
            
            self.indicatorViewCenterXConstraint = self.indicatorView.centerXAnchor.constraint(equalTo: sender.centerXAnchor)
            
            self.indicatorViewCenterXConstraint?.isActive = true
            
            self.view.layoutIfNeeded()
        }
        
        tableView.reloadData()
    }
    
    func fetchCurrentUserInfo() {
        
        UserManager.shared.getLoginUserInfo()
    }
    
    func setupSearchBar() {
        
        view.addSubview(searchbarStackView)
        
        searchbarStackView.addSubview(searchBar)
        
        searchbarStackView.addSubview(searchImage)
        
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
            searchImage.topAnchor.constraint(equalTo: searchbarStackView.topAnchor),
            searchImage.rightAnchor.constraint(equalTo: searchbarStackView.rightAnchor),
            searchImage.bottomAnchor.constraint(equalTo: searchbarStackView.bottomAnchor),
            searchImage.leftAnchor.constraint(equalTo: searchBar.rightAnchor)
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
        
        titleStackView.addArrangedSubview(addButton)
        
        searchButton.addTarget(self, action: #selector(didTouchSearchBtn), for: .touchUpInside)
        
        addButton.addTarget(self, action: #selector(didTouchAddBtn), for: .touchUpInside)

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
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let randomImage = projectBackground.randomElement() else { return UITableViewCell() }
        switch checkButton {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProcessingCell") as? ProcessingTableViewCell else { return UITableViewCell() }
            cell.titleLabel.text = "Handsome Boy"
            cell.dateLabel.text = "2020/01/01"
            cell.hourLabel.text = "720(30Day)"
            cell.backImage.image = UIImage(named: "\(randomImage)")
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedCell") as? CompletedTableViewCell else { return UITableViewCell() }
            cell.titleLabel.text = "Handsome Boy"
            cell.dateLabel.text = "2020/01/01"
            cell.hourLabel.text = "720(30Day)"
            cell.backImage.image = UIImage(named: "\(randomImage)")
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension PersonalViewController: UITableViewDelegate {
    
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

