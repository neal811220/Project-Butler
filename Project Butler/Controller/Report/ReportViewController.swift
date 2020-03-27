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
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.isPagingEnabled = true
        
        collectionView.register(ContainerCollectionViewCell.self, forCellWithReuseIdentifier: ContainerCollectionViewCell.identifier)
        
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.delegate = self
        
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
                
        return collectionView
    }()
    
    let indicatorView: UIView = {
        
        let view = UIView()
        
        view.backgroundColor = UIColor.B2
        
        view.layer.cornerRadius = 4
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var workLogContent: [WorkLogContent] = []
        
    var projectDetail: ProjectDetail!
    
    var projectMembers: [AuthInfo] = []
    
    var titleCollectionViewArray = ["Project", "User", "Item"]
    
    var titleButtonIndexPath: IndexPath?
    
    var indicatorViewCenterXConstraint: NSLayoutConstraint?
    
    var indicatorViewLeftConstraint: NSLayoutConstraint?
    
    var indicatorViewWidthConstraint: NSLayoutConstraint?
    
    lazy var reportManagers: [ChartProvider] = [
        
        DateReportManager(workLogContent: workLogContent, projectMembers: projectMembers, projectDetail: projectDetail),
        
        MemberReportManager(workLogContent: workLogContent, projectMembers: projectMembers, projectDetail: projectDetail),
        
        WorkItemReportManager(workLogContent: workLogContent, projectMembers: projectMembers, projectDetail: projectDetail)
    ]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.title = LargeTitle.report.rawValue

        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.B2!]
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
                
        setupTitleCollectionView()
        
        setupContentCollectionView()
        
        setupIndicatorView()
                
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
           
            contentcollectionView.topAnchor.constraint(equalTo: titlecollectionView.bottomAnchor, constant: 20),
            
            contentcollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            
            contentcollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            contentcollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupIndicatorView() {
        
        view.addSubview(indicatorView)
        
        indicatorViewCenterXConstraint = indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        
        indicatorViewLeftConstraint = indicatorView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.frame.width / 5.59)
        
        indicatorViewWidthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: (view.frame.width / 6 / 3))
        
        NSLayoutConstraint.activate([

            indicatorView.topAnchor.constraint(equalTo: titlecollectionView.bottomAnchor, constant: 2),

            indicatorView.heightAnchor.constraint(equalToConstant: 2),
            
            indicatorViewWidthConstraint!,
            
            indicatorViewLeftConstraint!
        ])
        
    }
    
    @objc func handleNext(sender: UIButton) {
        
        guard let indexPath = titleButtonIndexPath else {
            
            return
        }
        
        contentcollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        UIView.animate(withDuration: 0.3) {

            self.indicatorViewLeftConstraint?.isActive = false

            self.indicatorViewCenterXConstraint?.isActive = false

            self.indicatorViewCenterXConstraint = self.indicatorView.centerXAnchor.constraint(equalTo: sender.centerXAnchor)

            self.indicatorViewCenterXConstraint?.isActive = true

            self.view.layoutIfNeeded()
        }
    }
    
    func didScrollContentCollectionView() {
        
    }
    
}

extension ReportViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        titleButtonIndexPath = indexPath
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        print("\(scrollView.contentOffset)")
//
//        let offSet = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y)
//
//        switch  scrollView.contentOffset {
//
//        case CGPoint(x: <#T##Int#>, y: <#T##Int#>):
//            <#code#>
//        default:
//            <#code#>
//        }
//    }
    
}

extension ReportViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        titleButtonIndexPath = indexPath
        if collectionView == titlecollectionView {

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReportTitleCell", for: indexPath) as? ReportTitleCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.titleButton.setTitle(titleCollectionViewArray[indexPath.row], for: .normal)
            
            cell.titleButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
            
            cell.titleButton.setTitleColor(UIColor.Black2, for: .normal)
            
            cell.titleButton.setTitleColor(UIColor.Black1, for: .selected)
            
            cell.titleButton.titleLabel?.font = UIFont(name: "AmericanTypewriter-Bold", size: 17)
                        
            cell.titleButtonIndexPath = { [weak self] in
            
                guard let strongSelf = self else {
                    
                    return
                }
                
                strongSelf.titleButtonIndexPath = indexPath
            }
            return cell

        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContainerCollectionViewCell.identifier, for: indexPath)
            
            guard let reportContentVC = UIStoryboard.report.instantiateViewController(withIdentifier: "ReportContentVC") as? ReportContentViewController else {
                return cell
            }
            
            addChild(reportContentVC)
            
            reportContentVC.reportManager = reportManagers[indexPath.row]
                        
            reportContentVC.projectDetail = projectDetail
            
            reportContentVC.projectMembers = projectMembers
            
            guard let reportView = reportContentVC.view else { return cell }
            
            cell.addSubview(reportView)
            
            reportView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                
                reportView.topAnchor.constraint(equalTo: cell.topAnchor),
                
                reportView.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                
                reportView.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
                
                reportView.bottomAnchor.constraint(equalTo: cell.bottomAnchor)
            ])
            
            reportContentVC.didMove(toParent: self)
            
            return cell
        }
    }
}

extension ReportViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == titlecollectionView {
            
            return CGSize(width: view.frame.width / 6, height: 40)
            
        } else {
            
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == titlecollectionView {
            
            return UIEdgeInsets(top: 0, left: view.frame.width / 8, bottom: 0, right: view.frame.width / 8)
            
        } else {
            
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == titlecollectionView {
            
            return CGFloat(view.frame.width / 8)
            
        } else {
            
            return 0.0
        }
    }
    
}

class ContainerCollectionViewCell: UICollectionViewCell {
    
}

extension UIView {
    
    static var identifier: String {
        
        return String(describing: self)
    }
}
