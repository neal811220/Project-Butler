////
////  ReportCollectionViewCell.swift
////  Project Butler
////
////  Created by Neal on 2020/2/19.
////  Copyright © 2020 neal812220. All rights reserved.
////
//
//import UIKit
//import AAInfographics
//
//class ReportContentCollectionViewCell: UICollectionViewCell {
//
//    @IBOutlet weak var tableView: UITableView!
//
//    var chartModel = AAChartModel()
//
//    override func awakeFromNib() {
//
//        tableView.delegate = self
//
//        tableView.dataSource = self
//
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//}
//
//extension ReportContentCollectionViewCell: UITableViewDelegate {
//
//
//}
//
//extension ReportContentCollectionViewCell: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReportContentCell", for: indexPath) as? ReportContentTableViewCell else {
//            return UITableViewCell()
//        }
//
//        let chartView = AAChartView()
//
//        chartView.translatesAutoresizingMaskIntoConstraints = false
//
//        chartView.aa_drawChartWithChartModel(chartModel)
//
//        cell.contentView.addSubview(chartView)
//
//        NSLayoutConstraint.activate([
//            chartView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
//            chartView.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor),
//            chartView.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor),
//            chartView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -100),
//            chartView.heightAnchor.constraint(equalToConstant: 600)
//        ])
//
//        tableView.rowHeight = UITableView.automaticDimension
//
//        return cell
//
//    }
//}
//
