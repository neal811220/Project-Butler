//
//  ReportContentViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/2/24.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit
import AAInfographics

class ReportContentViewController: UIViewController {

    lazy var tableView: UITableView = {
        
        let tableview = UITableView()
        
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        tableview.dataSource = self
        
        let nib = UINib(nibName: "ReportChartViewTableViewCell", bundle: nil)
        
        tableview.register(nib, forCellReuseIdentifier: "ReportChartViewCell")
        
        tableview.rowHeight = UITableView.automaticDimension
        
        tableview.separatorStyle = .none
        
        return tableview
    }()
    
    var chartModel = AAChartModel()
    
    var workLogContent: [WorkLogContent] = []
    
    let reportManager = ReportManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    func setupTableView() {
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

extension ReportContentViewController: UITableViewDelegate {
    
    
}

extension ReportContentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReportChartViewCell", for: indexPath) as? ReportChartViewTableViewCell else {
            return UITableViewCell()
        }
        
        let chartView = AAChartView()
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        
        chartModel = reportManager.dateChartView(workLogContent: workLogContent)
        
        chartView.aa_drawChartWithChartModel(chartModel)
            
        cell.contentView.addSubview(chartView)
        
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            chartView.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor),
            chartView.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor),
            chartView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -100),
            chartView.heightAnchor.constraint(equalToConstant: 600)
        ])
        
        tableView.rowHeight = UITableView.automaticDimension
        
        return cell
        
    }
}
