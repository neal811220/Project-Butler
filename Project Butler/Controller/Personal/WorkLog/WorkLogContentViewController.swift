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
    
    lazy var workItemPickerView: UIPickerView = {
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        pickerView.dataSource = self
        
        return pickerView
    }()
    
    let startTimePickerView: UIDatePicker = {
        
        let startDatePicker = UIDatePicker()
        
        startDatePicker.datePickerMode = .time
        
        startDatePicker.date = NSDate() as Date
        
        return startDatePicker
    }()
    
    let endTimePickerView: UIDatePicker = {
        
        let endDatePicker = UIDatePicker()
        
        endDatePicker.datePickerMode = .time
        
        endDatePicker.date = NSDate() as Date
        
        return endDatePicker
    }()
    
    let datePickerView: UIDatePicker = {
        
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = .date
        
        datePicker.date = NSDate() as Date
        
        return datePicker
    }()
    
    var selectedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    var workItemArray: [String] = []
    
    var startText = ""
    
    var endText = ""
    
    var dateText = ""
    
    var timeFormatter = DateFormatter()
    
    var dateFormatter = DateFormatter()
    
    var timeStatus = false
    
    var durationH = 0
    
    var durationM = 0
    
    var problem = ""
    
    var workItem = ""
    
    var workContent = ""
    
    var documentID = ""
        
    var passContentData:((WorkLogContent) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        setupTimePicker()
        
        setupDatePicker()
    }
    
    override func viewDidLayoutSubviews() {
        
        tableView.layer.cornerRadius = 30
    }
    
    func setupTableView() {
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 4),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupTimePicker() {
        
        timeFormatter.dateFormat = "HH:mm"
        
        startTimePickerView.locale = NSLocale(localeIdentifier: "en-US") as Locale
        
        startTimePickerView.addTarget(self, action: #selector(timePickerChanged), for: .valueChanged)
        
        endTimePickerView.locale = NSLocale(localeIdentifier: "en-US") as Locale
        
        endTimePickerView.addTarget(self, action: #selector(timePickerChanged), for: .valueChanged)
    }
    
    func setupDatePicker() {
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        datePickerView.locale = NSLocale(localeIdentifier: "en-US") as Locale
        
        datePickerView.addTarget(self, action: #selector(didTapDatePicker), for: .valueChanged)
    }
    
    @objc func didTapDatePicker() {
        
        dateText = dateFormatter.string(from: datePickerView.date)
        
        tableView.reloadData()
        
        view.endEditing(true)
    }
    
    @objc func didTapCancelButton() {
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapSaveButton() {
        
        tableView.reloadData()
        
        guard let uid = UserDefaults.standard.value(forKey: "userID") as? String else {
            return
        }
        
        let workLog = WorkLogContent(userID: uid, date: dateText,workItem: workItem, startTime: startText, endTime: endText, problem: problem, workContent: workContent, hour: Int(durationH), minute: durationM)
        
        ProjectManager.shared.uploadUserWorkLog(documentID: documentID, workLogContent: workLog) { (result) in
            
            switch result {
                
            case .success:
                
                print("Success")
                
                PBProgressHUD.showSuccess(text: "Success!", viewController: self)
                
                self.dismiss(animated: true) {
                    
                    self.passContentData?(workLog)
                }
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    @objc func timePickerChanged() {
        
        startText = timeFormatter.string(from: startTimePickerView.date)
        
        let startTime = startTimePickerView.date
        
        let endTime = endTimePickerView.date
        
        if endTime >= startTime {
            
            timeStatus = true
            
        } else {
            
            timeStatus = false
        }
        
        let start =  startTime.timeIntervalSince1970
        
        let end = endTime.timeIntervalSince1970
        
        durationM = Int((end - start) / 60)
        
        durationH = durationM / 60
        
        durationM = Int(durationM) % 60
        
        endText = timeFormatter.string(from: endTimePickerView.date)
        
        tableView.reloadData()
        
        view.endEditing(true)
    }
    
}

extension WorkLogContentViewController: UITableViewDelegate {
    
}

extension WorkLogContentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkLogContentCell", for: indexPath) as? WorkLogContentTableViewCell else {
            return UITableViewCell()
        }
        
        if timeStatus {
            
            cell.endTimeTextField.textColor = UIColor.Black1
            
        } else {
            
            cell.endTimeTextField.textColor = UIColor.red
            
        }
                
        workItem = cell.workItemTextField.text ?? ""
        
        cell.textViewDidEdit = {
            
            self.problem = $0
            
            self.workContent = $1
        }
        
        cell.dateTextField.inputView = datePickerView
        
        cell.dateTextField.text = dateText
        
        cell.selectedBackgroundView = selectedBackgroundView
        
        cell.workItemTextField.inputView = workItemPickerView
        
        cell.startTimeTextField.inputView = startTimePickerView
        
        cell.endTimeTextField.inputView = endTimePickerView
        
        cell.startTimeTextField.text = startText
        
        cell.endTimeTextField.text = endText
                
        cell.cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
        cell.saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        
        cell.didChangeTextViewHeight = {
            
            if $0 == true {
                
                tableView.reloadData()
            }
        }
        return cell
    }
}

extension WorkLogContentViewController: UIPickerViewDelegate {
    
    
}

extension WorkLogContentViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return workItemArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return workItemArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let textField = self.view.viewWithTag(10) as? UITextField
        
        textField?.text = workItemArray[row]
        
        view.endEditing(true)
    }
    
}
