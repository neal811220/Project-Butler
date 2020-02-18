//
//  WorkLogTableViewCell.swift
//  Project Butler
//
//  Created by Neal on 2020/2/15.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class WorkLogTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var timeSpentLabel: UILabel!
    
    @IBOutlet weak var workItemLabel: UILabel!
    
    @IBOutlet weak var problemLabel: UILabel!
    
    @IBOutlet weak var workContentLabel: UILabel!
    
    @IBOutlet weak var chatButton: UIButton!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setLayer(view: timeSpentLabel)
        
        setLayer(view: workItemLabel)
        
        setLayer(view: problemLabel)
        
        setLayer(view: workContentLabel)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLayer(view: UIView) {
        
        view.layer.borderColor = UIColor.lightGray.cgColor
        
        view.layer.borderWidth = 1
        
        view.layer.cornerRadius = 10
        
        view.clipsToBounds = true
    }    
}
