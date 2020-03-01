//
//  WorkLogTableViewCell.swift
//  Project Butler
//
//  Created by Neal on 2020/2/15.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class WorkLogTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leftView: UIView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var timeSpentLabel: UILabel!
    
    @IBOutlet weak var workItemLabel: UILabel!
    
    @IBOutlet weak var problemLabel: UILabel!
    
    @IBOutlet weak var workContentLabel: UILabel!
    
    @IBOutlet weak var chatButton: UIButton!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setLayer(label: timeSpentLabel)
        
        setLayer(label: workItemLabel)
        
        setLayer(label: problemLabel)
        
        setLayer(label: workContentLabel)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLayer(label: UILabel) {
        
        label.numberOfLines = 0
    }    
}
