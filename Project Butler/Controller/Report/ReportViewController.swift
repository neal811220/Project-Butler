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
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.isPagingEnabled = true
        
        collectionView.register(nib, forCellWithReuseIdentifier: "ReportContentCell")
                
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.delegate = self
        
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    var chartModel: AAChartModel!
    
    var chartType: AAChartType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = LargeTitle.report.rawValue
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.B2]
        
        setupTitleCollectionView()
        
        setupContentCollectionView()
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
            contentcollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupContentView() -> AAChartView {
        
        let chartView:AAChartView = AAChartView()
        
        self.view.addSubview(chartView)
                
        chartView.translatesAutoresizingMaskIntoConstraints = false
        
        chartView.frame = self.view.bounds
        
//        NSLayoutConstraint.activate([
//            chartView.topAnchor.constraint(equalTo: self.view.topAnchor),
//            chartView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
//            chartView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
//            chartView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
//        ])
        
        chartModel = AAChartModel()
            .chartType(.pie)//Can be any of the chart types listed under `AAChartType`.
            .animationType(.bounce)
            .title("TITLE")//The chart title
            .subtitle("subtitle")//The chart subtitle
            .dataLabelsEnabled(false) //Enable or disable the data labels. Defaults to false
            .tooltipValueSuffix("USD")//the value suffix of the chart tooltip
            .categories(["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                         "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"])
            .colorsTheme(["#fe117c","#ffc069","#06caf4","#7dffc0"])
            .series([
                AASeriesElement()
                    .name("Tokyo")
                    .data([7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]),
                AASeriesElement()
                    .name("New York")
                    .data([0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5]),
                AASeriesElement()
                    .name("Berlin")
                    .data([0.9, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6, 17.9, 14.3, 9.0, 3.9, 1.0]),
                AASeriesElement()
                    .name("London")
                    .data([3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8]),
                    ])
        chartView.aa_drawChartWithChartModel(chartModel!)
        
        return chartView
    }
    
}

extension ReportViewController: UICollectionViewDelegate {
    
    
}

extension ReportViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
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
            
            cell.tableView.delegate = self
            
            cell.tableView.dataSource = self
            
            cell.tableView.rowHeight = self.view.frame.height
            
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
            
            return CGSize(width: view.frame.width, height: view.frame.height)
        }
        
    }
}

extension ReportViewController: UITableViewDelegate {
    
    
}

extension ReportViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReportContentCell", for: indexPath) as? ReportContentTableViewCell else {
            return UITableViewCell()
            
        }
        
        cell.chartContentView.addSubview(setupContentView())
        
        return cell
    }
    
    
}
