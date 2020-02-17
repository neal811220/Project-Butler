//
//  WorkContentViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/2/17.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class WorkLogContentViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView()
        
        let nib = UINib(nibName: "WorkLogContentTableViewCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "WorkLogContentCell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        
        tableView.layer.cornerRadius = 30
    }
    
    func setupTableView() {
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 3),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func didTapCancelButton() {
        
        dismiss(animated: true, completion: nil)
    }

}

extension WorkLogContentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkLogContentCell", for: indexPath) as? WorkLogContentTableViewCell else {
            return UITableViewCell()
        }
        cell.cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return cell
    }
}


extension WorkLogContentViewController: UITableViewDelegate {
    
    
}
