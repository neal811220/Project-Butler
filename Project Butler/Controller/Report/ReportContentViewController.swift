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
        
        let pickerNib = UINib(nibName: "ReportChartPickerTableViewCell", bundle: nil)
        
        let workLogNib = UINib(nibName: "WorkLogTableViewCell", bundle: nil)
        
        tableview.register(nib, forCellReuseIdentifier: "ReportChartViewCell")
        
        tableview.register(pickerNib, forCellReuseIdentifier: "ReportPickerViewCell")
        
        tableview.register(workLogNib, forCellReuseIdentifier: "WorkLogCell")
        
        tableview.rowHeight = UITableView.automaticDimension
        
        tableview.separatorStyle = .none
        
        return tableview
    }()
    
    lazy var reportPickerView: UIPickerView = {
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        pickerView.dataSource = self
        
        return pickerView
    }()
    
    var chartModel = AAChartModel()
    
    var workLogContent: [WorkLogContent] = []
    
    var filterWorkLogContent: [WorkLogContent] = []
    
    var reportPickerContentArray: [String] = ["test1", "test2", "test3"]
    
    var projectDetail: NewProject?
    
    let reportManager = ReportManager()
    
    var chartView: AAChartView!
    
    var selectDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 2 {
            
            return filterWorkLogContent.count
        } else {
            
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section{
            
        case 0:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReportChartViewCell", for: indexPath) as? ReportChartViewTableViewCell else {
                return UITableViewCell()
            }
            
            chartView = AAChartView()
            
            chartView.delegate = self as AAChartViewDelegate
                   
            chartModel = chartModel.touchEventEnabled(true)
            
            chartView.translatesAutoresizingMaskIntoConstraints = false
            
            chartModel = reportManager.dateChartView(workLogContent: workLogContent)
            
            chartView.aa_drawChartWithChartModel(chartModel)
            
            cell.contentView.addSubview(chartView)
            
            NSLayoutConstraint.activate([
                chartView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                chartView.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor),
                chartView.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor),
                chartView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                chartView.heightAnchor.constraint(equalToConstant: 600)
            ])
            
            tableView.rowHeight = UITableView.automaticDimension
            
            return cell
            
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReportPickerViewCell", for: indexPath) as? ReportChartPickerTableViewCell else {
                return UITableViewCell()
            }
            
            cell.itemPicker.inputView = reportPickerView
            
            return cell
            
        case 2:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkLogCell", for: indexPath) as? WorkLogTableViewCell else {
                return UITableViewCell()
            }
            
            cell.dateLabel.textColor = UIColor(patternImage: UIImage(named: projectDetail!.color)!)
            
            cell.timeLabel.textColor = UIColor(patternImage: UIImage(named: projectDetail!.color)!)
            
            cell.dateLabel.text = filterWorkLogContent[indexPath.row].date
            
            cell.timeLabel.text = "\(filterWorkLogContent[indexPath.row].startTime) - \(filterWorkLogContent[indexPath.row].endTime)"
            
            if filterWorkLogContent[indexPath.row].hour == 0 {
                
                cell.timeSpentLabel.text = "\(filterWorkLogContent[indexPath.row].minute) Minute"
                
            } else {
                
                cell.timeSpentLabel.text = "\(filterWorkLogContent[indexPath.row].hour) Hour, \(filterWorkLogContent[indexPath.row].minute) Minute"
            }
            
            cell.workItemLabel.text = filterWorkLogContent[indexPath.row].workItem
            
            cell.workContentLabel.text = filterWorkLogContent[indexPath.row].workContent
            
            cell.problemLabel.text = filterWorkLogContent[indexPath.row].problem
            
            cell.leftView.backgroundColor = UIColor(patternImage: UIImage(named: projectDetail!.color)!)
            
            return cell
            
        default:
            
            return UITableViewCell()
        }
        
        
    }
}

extension ReportContentViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let textField = self.view.viewWithTag(20) as? UITextField
        
        textField?.text = reportPickerContentArray[row]
        
        view.endEditing(true)
    }
}

extension ReportContentViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return reportPickerContentArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return reportPickerContentArray[row]
    }
    
}

extension ReportContentViewController: AAChartViewDelegate {
    open func aaChartViewDidFinishedLoad(_ aaChartView: AAChartView) {
       print("🙂🙂🙂, AAChartView Did Finished Load!!!")
    }
    
    open func aaChartView(_ aaChartView: AAChartView, moveOverEventMessage: AAMoveOverEventMessageModel) {
        
        filterWorkLogContent = []
        
        print("🔥selected point series element name: \(moveOverEventMessage.category ?? "")")
        selectDate = moveOverEventMessage.category ?? ""
        
        for item in workLogContent {
            
            if item.date == selectDate {
                
                filterWorkLogContent.append(item)
            }
        }
        
        tableView.reloadData()
    }
}
