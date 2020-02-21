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
        
        let nib = UINib(nibName: "ReportContentCollectionViewCell", bundle: nil)
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.isPagingEnabled = true
        
        collectionView.register(nib, forCellWithReuseIdentifier: "ReportContentCell")
        
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.delegate = self
        
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
                
        return collectionView
    }()
    
    lazy var reportPickerView: UIPickerView = {
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        pickerView.dataSource = self
        
        return pickerView
    }()
        
    var timeArray: [String] = []
    
    var contentArray: [String] = []
    
    var workLogContent: [WorkLogContent] = []
    
    var members: [AuthInfo] = []
    
    var pickerContent: [String] = []
    
//    var chartView:AAChartView = {
//
//        let view = AAChartView()
//
//        view.translatesAutoresizingMaskIntoConstraints = false
//
//        return view
//    }()
    
    let reportManager = ReportManager()
    
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

extension ReportViewController: UIPickerViewDelegate {

}

extension ReportViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerContent.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerContent[row]
    }
    
}

extension ReportViewController: UICollectionViewDelegate {
    
    
}

extension ReportViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == titlecollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReportTitleCell", for: indexPath) as? ReportTitleCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            return cell
            
        } else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReportContentCell", for: indexPath) as? ReportContentCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            var chartModel = AAChartModel()
            
            if indexPath.row == 0 {
                
                chartModel = reportManager.dateChartView(workLogContent: workLogContent)
                
            } else {
                
                chartModel = reportManager.personalChartView(workLogContent: workLogContent)
                
            }
            
            cell.chartModel = chartModel
                        
            cell.tableView.register(UINib(nibName: "ReportContentTableViewCell", bundle: nil), forCellReuseIdentifier: "ReportContentCell")
            
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
