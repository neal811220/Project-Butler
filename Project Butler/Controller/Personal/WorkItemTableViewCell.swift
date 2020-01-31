//
//  WorkItemTableViewCell.swift
//  Project Butler
//
//  Created by Neal on 2020/1/31.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class WorkItemTableViewCell: UITableViewCell {

    @IBOutlet weak var workItemLabel: UILabel!
    
    @IBAction func deleteButton(_ sender: UIButton) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        workItemLabel.layer.cornerRadius = 15
        
        workItemLabel.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
