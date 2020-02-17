//
//  WorkLogViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/2/15.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class WorkLogViewController: UIViewController {

    let projectlabel: UILabel = {
        
        let label = UILabel()
        
        label.textColor = UIColor.B1
        
        label.text = "ChangHua Got Rich"
        
        label.textAlignment = .center
        
        label.font = UIFont.boldSystemFont(ofSize: 22)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let addLogButton: UIButton = {
        
        let button = UIButton()
        
        let image = UIImage.asset(.Icons_32px_AddWorkLog)
        
        button.setImage(image, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView()
        
        let nib = UINib(nibName: "WorkLogTableViewCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "WorkLogCell")
        
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    lazy var collectionView: UICollectionView = {
        
        let nib = UINib(nibName: "WorkLogCollectionViewCell", bundle: nil)
        
        let numberNib = UINib(nibName: "NumberCollectionViewCell", bundle: nil)
        
        let layout = UICollectionViewFlowLayout()
        
         layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(nib, forCellWithReuseIdentifier: "WorkLogCell")
        
        collectionView.register(numberNib, forCellWithReuseIdentifier: "NumberCell")
        
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.delegate = self
        
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = LargeTitle.workLog.rawValue
        
        setupProjectTitle()
        
        setupCollectionView()
        
        setupTableView()
        
        // Do any additional setup after loading the view.
    }
    
    func setupProjectTitle() {
        
        view.addSubview(projectlabel)
        
        view.addSubview(addLogButton)
        
        addLogButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            projectlabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            projectlabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            projectlabel.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
            projectlabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            addLogButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            addLogButton.leftAnchor.constraint(equalTo: projectlabel.rightAnchor, constant: 10),
            addLogButton.heightAnchor.constraint(equalToConstant: 30),
            addLogButton.widthAnchor.constraint(equalToConstant: 30)
        ])

    }
    
    func setupCollectionView() {
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: addLogButton.bottomAnchor, constant: 30),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.widthAnchor.constraint(equalToConstant: view.frame.width / 3),
            collectionView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setupTableView() {
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 3),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func didTapAddButton() {
        
        guard let workLogContentVC = UIStoryboard.personal.instantiateViewController(withIdentifier: "WorkLogContentVC") as? WorkLogContentViewController else {
            return
        }
        
        present(workLogContentVC, animated: true, completion: nil)
    }

}

extension WorkLogViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 2 {
            
            guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "NumberCell", for: indexPath) as? NumberCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.numberLabel.text = "+\(1)"
            
            return cell
            
        } else {
            
            guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "WorkLogCell", for: indexPath) as? WorkLogCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            return cell
        }
    }
}

extension WorkLogViewController: UICollectionViewDelegate {
    
}

extension WorkLogViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
}


extension WorkLogViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkLogCell", for: indexPath) as? WorkLogTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
}

extension WorkLogViewController: UITableViewDelegate {
    
    
}
