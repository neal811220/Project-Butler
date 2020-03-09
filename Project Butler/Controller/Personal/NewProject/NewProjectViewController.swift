//
//  CreateNewProjectViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/2/3.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit
import Firebase

class NewProjectViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView()
        
        let topNib = UINib(nibName: "NewProjectTableViewCell", bundle: nil)
        
        let workItemNib = UINib(nibName: "WorkItemTableViewCell", bundle: nil)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.dataSource = self
        
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(topNib, forCellReuseIdentifier: "cell")
        
        tableView.register(workItemNib, forCellReuseIdentifier: "workItemCell")
        
        tableView.backgroundColor = UIColor.Gray1
                
        tableView.layer.cornerRadius = 60
        
        tableView.separatorStyle = .none
        
        
        return tableView
    }()
    
    let backgroundView: UIView = {
        let bv = UIView()
        bv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bv.layer.cornerRadius = 60
        bv.backgroundColor = UIColor.Gray1
        bv.translatesAutoresizingMaskIntoConstraints = false
        return bv
    }()
    
    let startDatePicker: UIDatePicker = {
        let startDatePicker = UIDatePicker()
        startDatePicker.datePickerMode = .date
        startDatePicker.date = NSDate() as Date
        return startDatePicker
    }()
    
    let endDatePicker: UIDatePicker = {
        let endDatePicker = UIDatePicker()
        endDatePicker.datePickerMode = .date
        endDatePicker.date = NSDate() as Date
        return endDatePicker
    }()
    
     var activityView: UIActivityIndicatorView = {
           let view = UIActivityIndicatorView()
           view.translatesAutoresizingMaskIntoConstraints = false
           return view
    }()
    
    let dateFormatter = DateFormatter()
    
    var membersArray: [FriendDetail] = []
    
    var workItemArray: [String] = []
    
    var startText = ""
    
    var endText = ""

    var inputProjectName = ""
    
    var workItemText = ""
    
    var seletedColor = ""
    
    var totalDays = 0
    
    var dateStatus = false
    
    var didCreate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let saveBarButton = UIBarButtonItem(title: "SAVE", style: .done, target: self, action: #selector(didTapSaveBarButton))
        
        saveBarButton.tintColor = UIColor.B2
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = LargeTitle.newProject.rawValue
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.B2]
        
        navigationItem.rightBarButtonItem = saveBarButton
        
        navigationController?.navigationBar.tintColor = UIColor.B2
        
        setupTableView()
        
        setupDatePicker()
        
        setupActivityView()
        
        getUserInfo()
    }
    
    func setupDatePicker() {
                        
        dateFormatter.dateFormat = "yyyy-MM-dd"
                        
        startDatePicker.locale = NSLocale(localeIdentifier: "en-US") as Locale
        
        startDatePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        
        endDatePicker.locale = NSLocale(localeIdentifier: "en-US") as Locale
        
        endDatePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
    }
    
    func setupActivityView() {
        
        view.addSubview(activityView)
        
        NSLayoutConstraint.activate([
           
            activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            activityView.heightAnchor.constraint(equalToConstant: view.frame.width / 10),
            
            activityView.widthAnchor.constraint(equalToConstant: view.frame.width / 10)
        ])
    }
    
    func setupTableView() {
        
        view.addSubview(backgroundView)
        
        backgroundView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
           
            backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            
            backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
           
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            
            tableView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor),
            
            tableView.rightAnchor.constraint(equalTo: backgroundView.rightAnchor),
            
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func getUserInfo() {
        
        guard let uid = UserDefaults.standard.value(forKey: "userID") as? String else {
            return
        }
        
        activityView.startAnimating()
        
        CurrentUserInfo.shared.getLoginUserInfo(uid: uid) { [weak self] (result) in
            
            guard let strongSelf = self else {
                return
            }
            
            switch result {
                
            case .success:
                
                print("Success")
                
                strongSelf.tableView.reloadData()
                
            case .failure(let error):
                
                print(error)
            }
            
            strongSelf.activityView.stopAnimating()
        }
    }
    
    @objc func datePickerChanged(datePicker: UIDatePicker) {
        
        let startDate = startDatePicker.date
        
        let endDate = endDatePicker.date
        
        if endDate >= startDate {
            
            dateStatus = true
            
        } else {
            
            dateStatus = false
        }
        
        guard let days = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day else { return }

        totalDays = days
        
        startText = dateFormatter.string(from: startDatePicker.date)
        
        endText = dateFormatter.string(from: endDatePicker.date)
        
        tableView.reloadData()
        
        view.endEditing(true)
        
    }
    
    @objc func didTapSaveBarButton(sender: UIBarButtonItem) {
        
        createProject()
    }
    
    func createProject() {
                
        guard let userId = UserDefaults.standard.value(forKey: "userID") as? String else {
            return
        }
        
        guard inputProjectName != "", startText != "", endText != "", membersArray.count != 0, dateStatus == true, workItemArray.count != 0 else {
            
            PBProgressHUD.showFailure(text: "Please Check Input", viewController: self)
            
            return
        }
        
        view.endEditing(true)
        
        let currentUserRef = UserManager.shared.db.collection("users").document(userId)
        
        let hours = totalDays * 24
        
        var memberID : [String] = []
        
        var userRef: [DocumentReference] = []
        
        let projectID = UserManager.shared.db.collection("users").document().documentID
        
        var memberUrl: [String] = []
        
        for member in membersArray {
            
            let ref = referenceArray(uid: member.userID)
            
            memberID.append(member.userID)
            
            userRef.append(ref)
            
            memberUrl.append(member.userImageUrl)
        }
        
        userRef.append(currentUserRef)
        
        memberID.append(userId)
       
        let newProject = ProjectDetail(projectName: inputProjectName,
                                    projectLeaderID: userId,
                                    color: seletedColor,
                                    startDate: startText,
                                    endDate: endText,
                                    projectMember: userRef,
                                    projectMemberID: memberID,
                                    totalDays: totalDays,
                                    totalHours: hours,
                                    projectID: projectID,
                                    workItems: workItemArray,
                                    memberImages: memberUrl,
                                    completedDate: startText,
                                    completedHour: hours,
                                    completedDays: totalDays
                                    )
    
        activityView.startAnimating()
        
        ProjectManager.shared.createNewProject(projectID: projectID, newProject: newProject, completion: { [weak self] result in
            
            switch result {
                
            case .success:
                
                guard let self = self else {
                    
                    return
                    
                }
                
                PBProgressHUD.showSuccess(text: "Added Successfully", viewController: self)
                
                self.inputProjectName = ""
                
                self.startText = ""
                
                self.endText = ""
                
                self.workItemText = ""
                
                self.workItemArray = []
                
                self.membersArray = []
                
                NotificationCenter.default.post(name: NSNotification.Name("RefreshProjectData"), object: nil)

                self.tableView.reloadData()
                                
            case .failure(let error):
                
                print(error)
            }
            
            self?.activityView.stopAnimating()
        })
    }
    
    func referenceArray(uid: String) -> DocumentReference{
        
        let ref = UserManager.shared.db.collection("users").document(uid)
        
        return ref
    }
    
}

extension NewProjectViewController: NewProjectTableViewCellDelegate {
    
    func passColor(_ newProjectTableViewCell: NewProjectTableViewCell, color: String) {
        
        seletedColor = color
    }
    
    func didSaveProject(_ newProjectTableViewCell: NewProjectTableViewCell, projectName: String, workItem: String) {
        
        inputProjectName = projectName
               
        workItemText = workItem
    }
    
}

extension NewProjectViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 1
            
        } else {
            
            return workItemArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? NewProjectTableViewCell else { return UITableViewCell() }

            if dateStatus {
                
                cell.endDateTextField.textColor = UIColor.Black2
                
            } else {
                
                cell.endDateTextField.textColor = UIColor.red
                
            }
            cell.delegate = self
            
            cell.leaderLabel.text = CurrentUserInfo.shared.userName
            
            cell.memeberInfo = membersArray
            
            cell.startDateTextField.inputView = startDatePicker
            
            cell.startDateTextField.text = startText
            
            cell.endDateTextField.inputView = endDatePicker
            
            cell.endDateTextField.text = endText
            
            cell.projectNameTextField.text = inputProjectName
            
            cell.workItemTextField.text = workItemText
                        
            cell.transitionToMemberVC = { [weak self] _ in
                
                guard let strongSelf = self else {
                    return
                }
                
                guard let selectMemeberVC = UIStoryboard.newProject.instantiateViewController(withIdentifier: "SelectMemeberVC") as? SelectMembersViewController else {
                    return
                }
                
                strongSelf.show(selectMemeberVC, sender: nil)
                
                selectMemeberVC.passSelectMemeber = {
                                        
                    strongSelf.membersArray = $0
                    
                    tableView.reloadData()
                }
            }
            
            cell.passInputText = { [weak self] text in
                
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.workItemArray.insert(text, at: 0)
                
                tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .left)
                
                let indexPath = IndexPath(row: strongSelf.workItemArray.endIndex - 1, section: 1)
                
                cell.workItemTextField.text = ""
                
                tableView.scrollToRow(at: indexPath, at: .none, animated: true)
            }
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "workItemCell", for: indexPath) as? WorkItemTableViewCell else { return UITableViewCell() }
            
            cell.workItemLabel.text = workItemArray[indexPath.row]
            
            cell.removeItem = {
                
                guard let indexPath = tableView.indexPath(for: $0) else {
                    return
                }
                
                self.workItemArray.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .right)
            }
            return cell
        }
        
    }
    
}

extension NewProjectViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}

extension NewProjectViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProcessingCell", for: indexPath) as? ProcessingCollectionViewCell else { return UICollectionViewCell()}
        return cell
    }
    
}
