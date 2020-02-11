//
//  WorkItemTableViewCell.swift
//  Project Butler
//
//  Created by Neal on 2020/2/3.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class WorkItemTableViewCell: UITableViewCell {

    @IBOutlet weak var workItemLabel: UILabel!
    
    @IBAction func pressedDelete(_ sender: UIButton) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        workItemLabel.layer.cornerRadius = 10
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
