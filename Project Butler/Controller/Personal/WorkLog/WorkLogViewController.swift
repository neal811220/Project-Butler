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
    
    let placeholderStackView: UIStackView = {
        
        let stackView = UIStackView()
        
        stackView.axis = NSLayoutConstraint.Axis.vertical
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let placeholderImage: UIImageView = {
        
        let image = UIImage.asset(.Icons_32px_LogDefaultImage)
        
        let imageView = UIImageView()
        
        imageView.image = image
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let placeholderLabel: UILabel = {
        
        let label = UILabel()
        
        label.textColor = UIColor.Gray3
        
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        label.text = "Add Work Log"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var completeProjectButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.setTitle("Complete", for: .normal)
        
        button.setTitleColor(UIColor.white, for: .normal)
        
        button.backgroundColor = UIColor.B2
        
        button.titleLabel?.font = UIFont(name: "AmericanTypewriter-Bold", size: 17)
        
        button.layer.borderWidth = 1
        
        button.layer.cornerRadius = 10
        
        button.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 4, height: 34)
        
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        button.layer.borderColor = UIColor.darkGray.cgColor
        
        button.isEnabled = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
        
    }()
    
    var members: [AuthInfo] = []
    
    var projectDetail: ProjectDetail?
    
    var personalWorkLogContent: [WorkLogContent] = [] {
        
        didSet {
            
            placeholderStackView.isHidden = true
            
        }
    }

    var projectWorkLogContent: [WorkLogContent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = LargeTitle.workLog.rawValue

        setupProjectTitle()
        
        setupCollectionView()
        
        setupTableView()
        
        setupDufaultStackView()
        
        projectlabel.text = projectDetail?.projectName
        
        fetchPersonalWorkLog(porjectID: projectDetail?.projectID ?? "")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if personalWorkLogContent.count != 0 {
            
            placeholderStackView.isHidden = true
            
        } else {
            
            placeholderStackView.isHidden = false
        }
        
        if projectDetail?.isCompleted == true {
            
            completeProjectButton.isHidden = true
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupCompleteProjectButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        completeProjectButton.isHidden = true
    }
    
    func setupCompleteProjectButton() {
        
        guard let navigationbar = navigationController?.navigationBar else {
            
            return
        }
        
        navigationController?.navigationBar.addSubview(completeProjectButton)
                
        completeProjectButton.addTarget(self, action: #selector(didTapCompletedProjectButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            completeProjectButton.bottomAnchor.constraint(equalTo: navigationbar.bottomAnchor, constant: -10),
            
            completeProjectButton.rightAnchor.constraint(equalTo: navigationbar.rightAnchor, constant: -15),
            
            completeProjectButton.widthAnchor.constraint(equalToConstant: navigationbar.frame.width / 4),
            
            completeProjectButton.heightAnchor.constraint(equalToConstant: navigationbar.frame.height / 3)
        ])
        
        completeProjectButton.addTarget(self, action: #selector(didTapCompletedProjectButton), for:
            .touchUpInside)
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
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            collectionView.widthAnchor.constraint(equalToConstant: view.frame.width / 4 + 20),
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
    
    func setupDufaultStackView() {
        
        view.addSubview(placeholderStackView)
        
        placeholderStackView.addSubview(placeholderImage)
        
        placeholderStackView.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            placeholderStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderStackView.widthAnchor.constraint(equalToConstant: view.frame.width / 3),
            placeholderStackView.heightAnchor.constraint(equalToConstant: view.frame.width / 3)
        ])
        
        NSLayoutConstraint.activate([
            placeholderImage.topAnchor.constraint(equalTo: placeholderStackView.topAnchor),
            placeholderImage.leftAnchor.constraint(equalTo: placeholderStackView.leftAnchor),
            placeholderImage.rightAnchor.constraint(equalTo: placeholderStackView.rightAnchor),
            placeholderImage.heightAnchor.constraint(equalToConstant: view.frame.width / 4)
        ])
        
        NSLayoutConstraint.activate([
            placeholderLabel.bottomAnchor.constraint(equalTo: placeholderStackView.bottomAnchor),
            placeholderLabel.rightAnchor.constraint(equalTo: placeholderStackView.rightAnchor),
            placeholderLabel.leftAnchor.constraint(equalTo: placeholderStackView.leftAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor)
        ])
        
    }
    
    func fetchPersonalWorkLog(porjectID: String) {
        
        ProjectManager.shared.fetchPersonalProjectWorkLog(projectID: porjectID) { (result) in
            
            switch result {
                
            case .success(let data):
                
                self.personalWorkLogContent = data
                
                self.personalWorkLogContent = self.personalWorkLogContent.sorted(by: {
                    $0.date < $1.date
                })
                                
                self.tableView.reloadData()
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    func fetchProjectWorkLog(projectID: String, completion: @escaping (Result<Void, Error>) -> Void ) {
        
        ProjectManager.shared.fetchProjectWorkLog(projectID: projectID) { [weak self] (result) in
            
            guard let strongSelf = self else {
                
                return
            }
            switch result {
                
            case .success(let data):
                
                strongSelf.projectWorkLogContent = data
                
                completion(.success(()))
                
            case .failure(let error):
                
                print(error)
                
                completion(.failure(error))
            }
        }
    }
    
    func completeProject() {
        
        guard let projectDetail = projectDetail else {
            
            return
        }
        
        PBProgressHUD.pbActivityView(text: "", viewController: self)
        
        ProjectManager.shared.completeProject(startDate: projectDetail.startDate, projectID: projectDetail.projectID) { [weak self] (result) in
            
            guard let strongSelf = self else {
                
                return
            }
            
            switch result {
                
            case .success:
                
                print("Success")
                
                PBProgressHUD.showSuccess(text: "Complete project", viewController: strongSelf)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    
                    strongSelf.navigationController?.popViewController(animated: true)
                }
                
            case .failure(let error):
                
                print(error)
            }
            
        }
    }
    
    @objc func didTapCompletedProjectButton() {
        
        let completeProjectAlert = UIAlertController(title: "Complete Project", message: "Are you sure you want to change the project status to completed?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let submit = UIAlertAction(title: "Submit", style: .default) { [weak self] (alert) in
            
            self?.completeProject()
        }
        
        completeProjectAlert.addAction(cancel)
        
        completeProjectAlert.addAction(submit)
        
        present(completeProjectAlert, animated: true, completion: nil)
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
            
            self.personalWorkLogContent.append($0)
            
            self.tableView.reloadData()
            
            self.collectionView.reloadData()
        }
        present(workLogContentVC, animated: true, completion: nil)
    }
    
    @objc func didTapReportButton() {
        
        guard let reportVC = UIStoryboard.report.instantiateViewController(withIdentifier: "ReportVC") as? ReportViewController else {
            
            return
        }
        
        guard let projectDetail = projectDetail else {
            return
        }
        
        fetchProjectWorkLog(projectID: projectDetail.projectID) { [weak self] (result) in
            
            guard let strongSelf = self else {
                
                return
            }
            
            switch result {
                
            case .success:
                                
                reportVC.workLogContent = strongSelf.projectWorkLogContent
                
                reportVC.projectDetail = projectDetail

                reportVC.projectMembers = strongSelf.members
                
                strongSelf.show(reportVC, sender: nil)
                
            case .failure(let error):
                
                print(error)
            }
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
            
            cell.memberImage.loadImage(members[indexPath.row].userImageUrl)
            
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
        
        return personalWorkLogContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkLogCell", for: indexPath) as? WorkLogTableViewCell else {
            return UITableViewCell()
        }
        
        cell.dateLabel.textColor = UIColor(patternImage: UIImage(named: projectDetail!.color)!)
        
        cell.timeLabel.textColor = UIColor(patternImage: UIImage(named: projectDetail!.color)!)
        
        cell.dateLabel.text = personalWorkLogContent[indexPath.row].date
        
        cell.timeLabel.text = "\(personalWorkLogContent[indexPath.row].startTime) - \(personalWorkLogContent[indexPath.row].endTime)"
        
        if personalWorkLogContent[indexPath.row].hour == 0 {
            
            cell.timeSpentLabel.text = "\(personalWorkLogContent[indexPath.row].minute) Minute"
            
        } else {
            
            cell.timeSpentLabel.text = "\(personalWorkLogContent[indexPath.row].hour) Hour, \(personalWorkLogContent[indexPath.row].minute) Minute"
        }
        
        cell.workItemLabel.text = personalWorkLogContent[indexPath.row].workItem
        
        cell.workContentLabel.text = personalWorkLogContent[indexPath.row].workContent
        
        cell.problemLabel.text = personalWorkLogContent[indexPath.row].problem
        
        cell.leftView.backgroundColor = UIColor(patternImage: UIImage(named: projectDetail!.color)!)
        
        return cell
    }
}

extension WorkLogViewController: UITableViewDelegate {
    
    
}
