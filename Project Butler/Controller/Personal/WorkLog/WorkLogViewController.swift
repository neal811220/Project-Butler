//
//  WorkLogViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/2/15.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class WorkLogViewController: UIViewController {
    
    let projectlabel: UILabel = {
        
        let label = UILabel()
        
        label.textColor = UIColor.B1
        
        label.text = "ChangHua Got Rich"
        
        label.textAlignment = .center
        
        label.font = UIFont(name: "AmericanTypewriter-Bold", size: 25)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let addLogButton: UIButton = {
        
        let button = UIButton()
        
        let image = UIImage.asset(.Icons_32px_AddWorkLog)
        
        button.setImage(image, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let reportButton: UIButton = {
        
        let button = UIButton()
        
        let image = UIImage.asset(.Icons_32px_Report)
        
        button.setImage(image, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView()
        
        let nib = UINib(nibName: "WorkLogTableViewCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "WorkLogCell")
        
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    lazy var collectionView: UICollectionView = {
        
        let nib = UINib(nibName: "WorkLogCollectionViewCell", bundle: nil)
        
        let numberNib = UINib(nibName: "NumberCollectionViewCell", bundle: nil)
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(nib, forCellWithReuseIdentifier: "WorkLogCell")
        
        collectionView.register(numberNib, forCellWithReuseIdentifier: "NumberCell")
        
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.delegate = self
        
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    let defaultStackView: UIStackView = {
        
        let stackView = UIStackView()
        
        stackView.axis = NSLayoutConstraint.Axis.vertical
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let defaultImage: UIImageView = {
        
        let image = UIImage.asset(.Icons_32px_LogDefaultImage)
        
        let imageView = UIImageView()
        
        imageView.image = image
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let defauLabel: UILabel = {
        
        let label = UILabel()
        
        label.textColor = UIColor.Gray3
        
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        label.text = "Add Work Log"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var members: [AuthInfo] = []
    
    var projectDetail: NewProject?
    
    var workLogContent: [WorkLogContent] = [] {
        
        didSet {
            
            defaultStackView.isHidden = true
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = LargeTitle.workLog.rawValue
        
        setupProjectTitle()
        
        setupCollectionView()
        
        setupTableView()
        
        setupDufaultStackView()
        
        projectlabel.text = projectDetail?.projectName
        
        fetchUserWorkLog(porjectID: projectDetail?.projectID ?? "")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if workLogContent.count != 0 {
            
            defaultStackView.isHidden = true
            
        } else {
            
            defaultStackView.isHidden = false
        }
        
    }
    
    func setupProjectTitle() {
        
        view.addSubview(projectlabel)
        
        view.addSubview(reportButton)
        
        view.addSubview(addLogButton)
        
        addLogButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        
        reportButton.addTarget(self, action: #selector(didTapReportButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            projectlabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            projectlabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            projectlabel.widthAnchor.constraint(greaterThanOrEqualToConstant: view.frame.width / 2),
            projectlabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            reportButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            reportButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            reportButton.heightAnchor.constraint(equalToConstant: 30),
            reportButton.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            addLogButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            addLogButton.rightAnchor.constraint(equalTo: reportButton.leftAnchor, constant: -5),
            addLogButton.heightAnchor.constraint(equalToConstant: 30),
            addLogButton.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        
        
    }
    
    func setupCollectionView() {
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: addLogButton.bottomAnchor, constant: 30),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.widthAnchor.constraint(equalToConstant: view.frame.width / 4 + 10),
            collectionView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setupTableView() {
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 3),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func fetchUserWorkLog(porjectID: String) {
        
        ProjectManager.shared.fetchUserProjectWorkLog(projectID: porjectID) { (result) in
            
            switch result {
                
            case .success(let data):
                
                self.workLogContent = data
                
                self.workLogContent = self.workLogContent.sorted(by: {
                    $0.date < $1.date
                })
                                
                self.tableView.reloadData()
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    func setupDufaultStackView() {
        
        view.addSubview(defaultStackView)
        
        defaultStackView.addSubview(defaultImage)
        
        defaultStackView.addSubview(defauLabel)
        
        NSLayoutConstraint.activate([
            defaultStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            defaultStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            defaultStackView.widthAnchor.constraint(equalToConstant: view.frame.width / 3),
            defaultStackView.heightAnchor.constraint(equalToConstant: view.frame.width / 3)
        ])
        
        NSLayoutConstraint.activate([
            defaultImage.topAnchor.constraint(equalTo: defaultStackView.topAnchor),
            defaultImage.leftAnchor.constraint(equalTo: defaultStackView.leftAnchor),
            defaultImage.rightAnchor.constraint(equalTo: defaultStackView.rightAnchor),
            defaultImage.heightAnchor.constraint(equalToConstant: view.frame.width / 4)
        ])
        
        NSLayoutConstraint.activate([
            defauLabel.bottomAnchor.constraint(equalTo: defaultStackView.bottomAnchor),
            defauLabel.rightAnchor.constraint(equalTo: defaultStackView.rightAnchor),
            defauLabel.leftAnchor.constraint(equalTo: defaultStackView.leftAnchor),
            defauLabel.topAnchor.constraint(equalTo: defaultImage.bottomAnchor)
        ])
        
    }
    
    @objc func didTapAddButton() {
        
        guard let workLogContentVC = UIStoryboard.personal.instantiateViewController(withIdentifier: "WorkLogContentVC") as? WorkLogContentViewController else {
            return
        }
        
        guard let projectDetail = projectDetail else {
            return
        }
        
        workLogContentVC.documentID = projectDetail.projectID
        
        workLogContentVC.workItemArray = projectDetail.workItems
        
        workLogContentVC.startDate = projectDetail.startDate
        
        workLogContentVC.endDate = projectDetail.endDate
        
        workLogContentVC.passContentData = {
            
            self.workLogContent.append($0)
            
            self.tableView.reloadData()
            
            self.collectionView.reloadData()
        }
        present(workLogContentVC, animated: true, completion: nil)
    }
    
    @objc func didTapReportButton() {
        
        guard let reportVC = UIStoryboard.report.instantiateViewController(withIdentifier: "ReportVC") as? ReportViewController else {
            return
        }
        
        guard let reportContentVC = UIStoryboard.report.instantiateViewController(withIdentifier: "ReportContentVC") as? ReportContentViewController else {
            return
        }
        
        guard let id = projectDetail?.projectID else {
            return
        }
        
        ProjectManager.shared.fetchTapProjectDetail(projectID: id) { (result) in
            
            switch result {
                
            case .success(let data):
                                
                reportVC.workLogContent = data
                
                reportContentVC.workLogContent = data
                
                reportContentVC.projectDetail = self.projectDetail
                
                reportVC.members = self.members
                
            case.failure(let error):
                
                print(error)
            }
            
            self.show(reportContentVC, sender: nil)
            
        }
        
    }
    
}

extension WorkLogViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if members.count >= 3 {
            
            return 3
            
        } else {
            
            return members.count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 2 {
            
            guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "NumberCell", for: indexPath) as? NumberCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.numberLabel.text = "+\(members.count - 2)"
            
            return cell
            
        } else {
            
            guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "WorkLogCell", for: indexPath) as? WorkLogCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            return cell
        }
    }
}

extension WorkLogViewController: UICollectionViewDelegate {
    
}

extension WorkLogViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
}


extension WorkLogViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return workLogContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkLogCell", for: indexPath) as? WorkLogTableViewCell else {
            return UITableViewCell()
        }
        
        cell.dateLabel.textColor = UIColor(patternImage: UIImage(named: projectDetail!.color)!)
        
        cell.timeLabel.textColor = UIColor(patternImage: UIImage(named: projectDetail!.color)!)
        
        cell.dateLabel.text = workLogContent[indexPath.row].date
        
        cell.timeLabel.text = "\(workLogContent[indexPath.row].startTime) - \(workLogContent[indexPath.row].endTime)"
        
        if workLogContent[indexPath.row].hour == 0 {
            
            cell.timeSpentLabel.text = "\(workLogContent[indexPath.row].minute) Minute"
            
        } else {
            
            cell.timeSpentLabel.text = "\(workLogContent[indexPath.row].hour) Hour, \(workLogContent[indexPath.row].minute) Minute"
        }
        
        cell.workItemLabel.text = workLogContent[indexPath.row].workItem
        
        cell.workContentLabel.text = workLogContent[indexPath.row].workContent
        
        cell.problemLabel.text = workLogContent[indexPath.row].problem
        
        cell.leftView.backgroundColor = UIColor(patternImage: UIImage(named: projectDetail!.color)!)
        
        return cell
    }
}

extension WorkLogViewController: UITableViewDelegate {
    
    
}
