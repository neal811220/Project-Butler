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
    
    var chartModel: AAChartModel!
    
    var chartType: AAChartType!
    
    var aaa = ["2020-01-01", "2020-03-02", "2020-02-05", "2020-05-30"]
    
    var timeArray: [String] = []
    
    var contentArray: [String] = []
    
    var workLogContent: [WorkLogContent] = []
    
    var members: [AuthInfo] = []
    
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
    
    func setupContentView() -> AAChartView {
        
        let chartView:AAChartView = AAChartView()
        
        var sortArray: [WorkLogContent] = []
        
        var dateArray: [String] = []
        
        var hourArray: [Int] = []
        
        var filterDate: [String] = []
        
        var seriesArray: [AASeriesElement] = []
        
        var allDate: [String] = []
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        
        sortArray = workLogContent.sorted(by: { $0.date < $1.date })
        
        for date in sortArray {
            
            allDate.append(date.date)
        }
        
        for count1 in 0 ..< allDate.count {
            
            var isSame = false
            
            for count2 in count1 + 1 ..< allDate.count {
                
                if allDate[count1] == allDate[count2] {
                    
                    isSame = true
                    
                } else { }
            }
            if !isSame {
                
                filterDate.append(allDate[count1])
            }
        }
        
        for date in filterDate {
            
            let filterdate = date.components(separatedBy: "-")
            
            let fulldate = "\(filterdate[1])-\(filterdate[2])"
            
            dateArray.append(fulldate)
            
        }
        
        for count1 in 0 ..< filterDate.count {
            
            var counter = 0
            
            for count2 in 0 ..< sortArray.count {
                
                if filterDate[count1] == sortArray[count2].date {
                    
                    counter += sortArray[count2].hour
                }
            }
            hourArray.append(counter)
        }
        
        for count1 in 0 ..< hourArray.count {
            
            var isSame = false
            
            for count2 in 0 ..< sortArray.count {
                
                for count3 in count2 + 1 ..< sortArray.count {
                    
                    if sortArray[count2].date == sortArray[count3].date {
                        
                        isSame = true
                        
                    } else {
                        
                        isSame = false
                        
                        if isSame == false {
                            
                            let series = AASeriesElement() .data([hourArray[count1]])
                            
                            seriesArray.append(series)
                        }
                    }
                }
                
            }
        }
        
        //         let series = [AASeriesElement() .name("") .data([])]
        
        chartModel = AAChartModel()
//            .chartType(.spline)//Can be any of the chart types listed under `AAChartType`.
//            .animationType(.bounce)
//            //            .title("ProjectName")//The chart title
//            //            .subtitle("subtitle")//The chart subtitle
//            .dataLabelsEnabled(false) //Enable or disable the data labels. Defaults to false
//            .tooltipValueSuffix("Hour")//the value suffix of the chart tooltip
//            .categories(dateArray)
//            .colorsTheme(["#fe117c","#ffc069","#06caf4","#7dffc0"])
//            .series(test)
        
        .chartType(.spline)//Can be any of the chart types listed under `AAChartType`.
        .animationType(.bounce)
        .title("TITLE")//The chart title
        .subtitle("subtitle")//The chart subtitle
        .dataLabelsEnabled(false) //Enable or disable the data labels. Defaults to false
        .tooltipValueSuffix("USD")//the value suffix of the chart tooltip
        .categories(dateArray)
        .colorsTheme(["#fe117c","#ffc069","#06caf4","#7dffc0"])
        .series([
            AASeriesElement()
                .name("Tokyo")
                .data([7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2]),
            AASeriesElement()
                .name("New York")
                .data([0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8]),
            AASeriesElement()
                .name("Berlin")
                .data([0.9, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6]),
            AASeriesElement()
                .name("London")
                .data([3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0]),
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
            
            cell.tableView.rowHeight = UITableView.automaticDimension
            
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
        
        let chartView = setupContentView()
        
        cell.contentView.addSubview(chartView)
        
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            chartView.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor),
            chartView.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor),
            chartView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -100),
            chartView.heightAnchor.constraint(equalToConstant: contentcollectionView.frame.height)
        ])
        
        return cell
        
    }
    
    
}
