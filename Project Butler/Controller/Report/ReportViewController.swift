//
//  ReportViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/1/31.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit
import AAInfographics

class ReportViewController: UIViewController {
    
    lazy var titlecollectionView: UICollectionView = {
        
        let nib = UINib(nibName: "ReportTitleCollectionViewCell", bundle: nil)
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(nib, forCellWithReuseIdentifier: "ReportTitleCell")
        
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.delegate = self
        
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
                
        return collectionView
    }()
    
    lazy var contentcollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.isPagingEnabled = true
        
        collectionView.register(ContainerCollectionViewCell.self, forCellWithReuseIdentifier: ContainerCollectionViewCell.identifier)
        
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.delegate = self
        
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
                
        return collectionView
    }()
    
    var workLogContent: [WorkLogContent] = []
    
    var projectDetail: NewProject?
    
    lazy var reportManagers: [ChartProvider] = [
        DateReportManager(workLogContent: workLogContent),
        PersonalReportManager(workLogContent: workLogContent),
        WorkItemReportManager(workLogContent: workLogContent)
    ]
    
//    let reportManager = ReportManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.title = LargeTitle.report.rawValue

        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.B2]
                
        setupTitleCollectionView()
        
        setupContentCollectionView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(titlecollectionView.frame)
        
        print(contentcollectionView.frame)
    }
    
    func setupTitleCollectionView() {
        
        view.addSubview(titlecollectionView)
        
        NSLayoutConstraint.activate([
            titlecollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titlecollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            titlecollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            titlecollectionView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupContentCollectionView() {
        
        view.addSubview(contentcollectionView)
        
        NSLayoutConstraint.activate([
            contentcollectionView.topAnchor.constraint(equalTo: titlecollectionView.bottomAnchor),
            contentcollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentcollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            contentcollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

extension ReportViewController: UICollectionViewDelegate {
    
    
}

extension ReportViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == titlecollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReportTitleCell", for: indexPath) as? ReportTitleCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContainerCollectionViewCell.identifier, for: indexPath)
            
            guard let reportContentVC = UIStoryboard.report.instantiateViewController(withIdentifier: "ReportContentVC") as? ReportContentViewController else {
                return cell
            }
            
            addChild(reportContentVC)
            
            reportContentVC.reportManager = reportManagers[indexPath.row]
            
            reportContentVC.projectDetail = projectDetail
            
            guard let reportView = reportContentVC.view else { return cell }
            
            cell.addSubview(reportView)
            
            reportView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                reportView.topAnchor.constraint(equalTo: cell.topAnchor),
                reportView.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                reportView.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
                reportView.bottomAnchor.constraint(equalTo: cell.bottomAnchor)
            ])
            
            reportContentVC.didMove(toParent: self)
            
            cell.backgroundColor = .red
            
            return cell
        }
    }
}

extension ReportViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == titlecollectionView {
            
            return CGSize(width: 50, height: 40)
            
        } else {
            
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        
    }
}

class ContainerCollectionViewCell: UICollectionViewCell {
    
    
}

extension UIView {
    
    static var identifier: String {
        
        return String(describing: self)
    }
}
