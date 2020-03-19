//
//  PersonalTableViewCellModel.swift
//  Project Butler
//
//  Created by Neal on 2020/3/16.
//  Copyright © 2020 neal812220. All rights reserved.
//

import Foundation
import UIKit

protocol PersonalTableViewCellModel {
    
    var identifier: String { get }
    
    func setCell(tableViewCell: UITableViewCell, button: UIButton, projectDetailData: [ProjectDetail], row: Int, passData: @escaping (() -> Void))
    
}

class PersonalTableViewProcessingCellModel: ProcessingTableViewCell, PersonalTableViewCellModel {
    
    let identifier = ProcessingTableViewCell.identifier
    
    func setCell(tableViewCell: UITableViewCell, button: UIButton, projectDetailData: [ProjectDetail], row: Int, passData: @escaping (() -> Void)) {
        
        guard let cell = tableViewCell as? ProcessingTableViewCell else {
            
            return
        }
        
        if button.isSelected {
            
            cell.leaderImage.isHidden = false
            
        } else {
            
            cell.leaderImage.isHidden = true
            
        }
        
        cell.selectionStyle = .none
        
        cell.backImage.image = UIImage(named: projectDetailData[row].color)
        
        cell.members = projectDetailData[row].memberImages
        
        cell.titleLabel.text = projectDetailData[row].projectName
        
        cell.dateLabel.text = "\(projectDetailData[row].startDate) - \(projectDetailData[row].endDate)"
        
        cell.hourLabel.text = "\(projectDetailData[row].totalHours) Hour (\(projectDetailData[row].totalDays) Day)"
        
        cell.transitionToMemberVC = passData
    }
}

class PersonalTableViewCompletedCellModel: CompletedTableViewCell, PersonalTableViewCellModel {
    
    let identifier = CompletedTableViewCell.identifier
    
    func setCell(tableViewCell: UITableViewCell, button: UIButton, projectDetailData: [ProjectDetail], row: Int, passData: @escaping (() -> Void)) {
        
        guard let cell = tableViewCell as? CompletedTableViewCell else {
            
            return
        }
        
        if button.isSelected {
            
            cell.leaderImage.isHidden = false
            
        } else {
            
            cell.leaderImage.isHidden = true
            
        }
        
        cell.selectionStyle = .none
        
        cell.backImage.image = UIImage(named: projectDetailData[row].color)
        
        cell.members = projectDetailData[row].memberImages
        
        cell.titleLabel.text = projectDetailData[row].projectName
        
        cell.dateLabel.text = "\(projectDetailData[row].startDate) - \(projectDetailData[row].endDate)"
        
        cell.hourLabel.text = "\(projectDetailData[row].totalHours) Hour (\(projectDetailData[row].totalDays) Day)"
        
        cell.completionDateLabel.text = projectDetailData[row].completedDate
        
        cell.completionHourLable.text = "\(projectDetailData[row].completedHour) Hour (\(projectDetailData[row].completedDays) Day)"
        
        cell.transitionToMemberVC = passData
    }
}
