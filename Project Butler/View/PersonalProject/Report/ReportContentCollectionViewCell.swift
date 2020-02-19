//
//  ReportCollectionViewCell.swift
//  Project Butler
//
//  Created by Neal on 2020/2/19.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class ReportContentCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.rowHeight = UITableView.automaticDimension
        // Initialization code
    }

}
