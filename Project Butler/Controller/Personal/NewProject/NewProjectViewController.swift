//
//  CreateNewProjectViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/2/3.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class NewProjectViewController: UIViewController {

    lazy var newProjectTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.dataSource = self
        tv.delegate = self
        tv.rowHeight = UITableView.automaticDimension
        let topNib = UINib(nibName: "NewProjectTableViewCell", bundle: nil)
        let workItemNib = UINib(nibName: "WorkItemTableViewCell", bundle: nil)
        tv.register(topNib, forCellReuseIdentifier: "cell")
        tv.register(workItemNib, forCellReuseIdentifier: "workItemCell")
        tv.backgroundColor = UIColor(named: "NewProjectBackgroung")
        tv.layer.cornerRadius = 60
        tv.separatorStyle = .none
        return tv
    }()
    
    let backgroundView: UIView = {
        let bv = UIView()
        bv.layer.cornerRadius = 60
        bv.backgroundColor = UIColor(red: 129/255, green: 206/255, blue: 157/255, alpha: 1/0)
        bv.translatesAutoresizingMaskIntoConstraints = false
        return bv
    }()
    
    let projectNametextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Your Project Name "
        tf.isEnabled = true
        tf.textColor = UIColor.white
        tf.font = UIFont.boldSystemFont(ofSize: 17)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let leaderLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.white
        lbl.font = UIFont.boldSystemFont(ofSize: 17)
        lbl.text = "Hello"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
//    lazy var memberCollectionView: UICollectionView = {
//        let layoutObject = UICollectionViewFlowLayout.init()
//        let member = UICollectionView(frame: CGRect.zero, collectionViewLayout: layoutObject)
//        let memberNib = UINib(nibName: "ProcessingTableViewCell", bundle: nil)
//        member.translatesAutoresizingMaskIntoConstraints = false
//        member.delegate = self
//        member.dataSource = self
//        member.register(memberNib, forCellWithReuseIdentifier: "ProcessingCell")
//        member.isScrollEnabled = true
//        layoutObject.scrollDirection = .vertical
//        return member
//    }()
    
    var leaderName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = LargeTitle.newProject.rawValue
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.B2]
        
        // Do any additional setup after loading the view.
        settingTableView()
    }
    
    func settingTableView() {
        
        view.addSubview(backgroundView)
        
        backgroundView.addSubview(newProjectTableView)
        
        
        NSLayoutConstraint.activate([
            
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 100),
            
            newProjectTableView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            newProjectTableView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor),
            newProjectTableView.rightAnchor.constraint(equalTo: backgroundView.rightAnchor),
            newProjectTableView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -100)
        ])
    }
    
    func settingLabel(text: String) -> UILabel{
        
        let leaderLabel: UILabel = {
            let lbl = UILabel()
            lbl.textColor = UIColor.white
            lbl.font = UIFont.boldSystemFont(ofSize: 17)
            lbl.text = text
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        return leaderLabel
    }
    
    func settingCollectionView() -> UICollectionView {
        
        var memberCollectionView: UICollectionView = {
               let layoutObject = UICollectionViewFlowLayout.init()
               let member = UICollectionView(frame: CGRect.zero, collectionViewLayout: layoutObject)
               let memberNib = UINib(nibName: "ProcessingTableViewCell", bundle: nil)
               member.translatesAutoresizingMaskIntoConstraints = false
               member.delegate = self
               member.dataSource = self
               member.register(memberNib, forCellWithReuseIdentifier: "ProcessingCell")
               member.isScrollEnabled = true
               layoutObject.scrollDirection = .vertical
               return member
           }()
        
        NSLayoutConstraint.activate([
            memberCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            memberCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            memberCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            memberCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        return memberCollectionView
    }
    
}

extension NewProjectViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        } else {
            return 3
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? NewProjectTableViewCell else { return UITableViewCell() }
            switch indexPath.row {

            case 0:

                cell.leftImageView?.image = UIImage.asset(.Icons_32px_ProjectName)

                cell.inputContentView.addSubview(projectNametextField)
                
                cell.titleLabel.text = ItemTitle.projectName.rawValue
                
                projectNametextField.frame = cell.inputContentView.frame
                
                cell.layoutIfNeeded()
            case 1:

                cell.leftImageView?.image = UIImage.asset(.Icons_32px_Leader)

                cell.inputContentView.addSubview(settingLabel(text: leaderName))
                
                cell.titleLabel.text = ItemTitle.projectLeader.rawValue
                
                leaderLabel.frame = cell.inputContentView.frame

                cell.layoutIfNeeded()
            case 2:
                
                cell.leftImageView?.image = UIImage.asset(.Icons_32px_Calendar)
                
                cell.inputContentView.addSubview(settingLabel(text: "2020/01/01~2020/01/30"))
                
                cell.titleLabel.text = ItemTitle.date.rawValue
                
                leaderLabel.frame = cell.inputContentView.frame

                cell.layoutIfNeeded()
            case 3:
                cell.leftImageView?.image = UIImage.asset(.Icons_32px_Member)
                
//                cell.inputContentView.addSubview(settingCollectionView())
                
                cell.titleLabel.text = ItemTitle.member.rawValue
                
                leaderLabel.frame = cell.inputContentView.frame
                
                cell.layoutIfNeeded()
            case 4:
                cell.leftImageView.image = UIImage.asset(.Icons_32px_WorkItem)
                
                cell.titleLabel.text = ItemTitle.workItem.rawValue
                
                cell.titleTopConstraint.constant += 10
                
            default:
                break
            }
            return cell
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "workItemCell") as? WorkItemTableViewCell else { return UITableViewCell() }
            return cell
        }
        
    }
    
}

extension NewProjectViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let memberVC = UIStoryboard.personal.instantiateViewController(withIdentifier: "MemberVC") as? MemberListViewController else { return }
        
        if indexPath.section == 0 && indexPath.row == 1 {
            
            memberVC.passLeaderName = {
                self.leaderName = $0
                self.newProjectTableView.reloadData()
            }
            
            show(memberVC, sender: nil)
        } else if indexPath.section == 0 && indexPath.row == 3{
            
            show(memberVC, sender: nil)
        }
    }
}

extension NewProjectViewController: UICollectionViewDelegate {
    
    
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

extension NewProjectViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 20, height: 20)
    }
}
