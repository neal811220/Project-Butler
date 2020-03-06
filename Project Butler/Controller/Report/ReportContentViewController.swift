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
    
    var reportPickerContentArray: [String] = ["test1", "test2", "test3"]
    
    var projectDetail: ProjectDetail?
    
    var filterWorkLogContent: [WorkLogContent] = []
    
    var reportManager: ChartProvider? {
        
        didSet {
            
            reportManager?.targetWorkLogContentsDidChangeHandler = { [weak self] (datas) in
                
                self?.filterWorkLogContent = datas
                
                self?.tableView.reloadData()
            }
            
            reportManager?.filterDidChangerHandler = { text in
                
                let textField = self.view.viewWithTag(40) as? UITextField
                
                textField?.text = text
            }
            
            reportManager?.didChangechartModel = { [weak self] (chartModel) in
                
               self?.chartView.aa_drawChartWithChartModel(chartModel)
            }
        }
    }
    
    var chartView: AAChartView!
    
    var selectDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        setupTableHeaderView()
    
        reportManager?.didSelectedPickerContent(at: 0)
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
    
    func setupTableHeaderView() {
        
        guard let reportManager = reportManager else { return }
        
        chartView = AAChartView()
        
        chartView.delegate = self as AAChartViewDelegate
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        
        chartView.aa_drawChartWithChartModel(reportManager.chartViewModel())
        
        chartView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 2)
        
        tableView.tableHeaderView = chartView
    }
    
}

extension ReportContentViewController: UITableViewDelegate {
    
}

extension ReportContentViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {

        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {

            return filterWorkLogContent.count

        } else {

            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section{

        case 0:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReportPickerViewCell", for: indexPath) as? ReportChartPickerTableViewCell else {
                return UITableViewCell()
            }
            
            cell.itemPicker.inputView = reportPickerView
            
            cell.itemPicker.text = reportManager?.currentPickerContent
            
            return cell

        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkLogCell", for: indexPath) as? WorkLogTableViewCell else {
                return UITableViewCell()
            }
            
            filterWorkLogContent = filterWorkLogContent.sorted(by: { return $0.startTime < $1.startTime })
            
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
        
//        let textField = self.view.viewWithTag(20) as? UITextField
        
//        textField?.text = reportPickerContentArray[row]
        
        reportManager?.didSelectedPickerContent(at: row)
        
        view.endEditing(true)
    }
}

extension ReportContentViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        guard let manager = reportManager else { return 0 }
        
        return manager.pickerContent.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        guard let manager = reportManager else { return nil }
        
        return manager.pickerContent[row]
    }
    
    
}

extension ReportContentViewController: AAChartViewDelegate {
    
    open func aaChartViewDidFinishedLoad(_ aaChartView: AAChartView) {
    
        print("🙂🙂🙂, AAChartView Did Finished Load!!!")
    }
    
    open func aaChartView(_ aaChartView: AAChartView, moveOverEventMessage: AAMoveOverEventMessageModel) {
        
        guard let category = moveOverEventMessage.category else { return }
        
        reportManager?.chartView(didSelected: category)
    }
}
