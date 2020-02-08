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
        bt.addTarget(self, action: #selector(didTapSearchButton(sender:)), for: .touchUpInside)
        return bt
    }()
    
    let addButton: UIButton = {
        let addrProjectImage = UIImage.asset(.Icons_32px_AddProjectButton)
        let bt = UIButton()
        bt.setImage(addrProjectImage, for: .normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.addTarget(self, action: #selector(didTapAddProjtButton(sender:)), for: .touchUpInside)
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
        st.backgroundColor = UIColor.red
        return st
    }()
    
    let processingButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("Processing", for: .normal)
        bt.setTitleColor(UIColor.B1, for: .normal)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.isEnabled = true
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
        bt.addTarget(self, action: #selector(didTapStatusButton), for: .touchUpInside)
        return bt
    }()
    
    let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.B2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
   lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.rowHeight = UITableView.automaticDimension
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.dataSource = self
        tb.separatorStyle = .none
        let nib = UINib(nibName: "PersonalProcessingTableViewCell", bundle: nil)
        tb.register(nib, forCellReuseIdentifier: "ProcessingCell")
        return tb
    }()
    
    var indicatorViewCenterXConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.title = LargeTitle.personalProject.rawValue
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.B2]
        
        settingStackView()
        
        settingButtonStackView()
        
        settingTableView() 
    }
    
    @objc func didTapSearchButton(sender: UIBarButtonItem) {
        
    }
    
    @objc func didTapAddProjtButton(sender: UIBarButtonItem) {
        
    }
    
    @objc func didTapStatusButton(sender: UIButton) {
        
        UIView.animate(withDuration: 0.5) {
            
            self.indicatorViewCenterXConstraint?.isActive = false
            
            self.indicatorViewCenterXConstraint = self.indicatorView.centerXAnchor.constraint(equalTo: sender.centerXAnchor)
            
            self.indicatorViewCenterXConstraint?.isActive = true
            
            self.view.layoutIfNeeded()
        }
    }
    
    func settingTableView() {
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 20),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func settingStackView() {
        
        guard let navigationbar = navigationController?.navigationBar else { return }
        
        navigationController?.navigationBar.addSubview(titleStackView)
        
        titleStackView.addArrangedSubview(searchButton)
        
        titleStackView.addArrangedSubview(addButton)
        
        NSLayoutConstraint.activate([
            titleStackView.bottomAnchor.constraint(equalTo: navigationbar.bottomAnchor, constant: -10),
            titleStackView.rightAnchor.constraint(equalTo: navigationbar.rightAnchor, constant: -15),
            titleStackView.widthAnchor.constraint(equalToConstant: navigationbar.frame.width / 5),
            titleStackView.heightAnchor.constraint(equalToConstant: navigationbar.frame.height / 3)
        ])
    }
    
    func settingButtonStackView() {
        
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProcessingCell") as? PersonalProcessingTableViewCell else { return UITableViewCell() }
        return cell
    }
}

