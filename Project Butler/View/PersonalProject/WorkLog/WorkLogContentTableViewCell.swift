//
//  WorkLogContentTableViewCell.swift
//  Project Butler
//
//  Created by Neal on 2020/2/17.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class WorkLogContentTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var workItemTextField: UITextField!
    
    @IBOutlet weak var startTimeTextField: UITextField!
    
    @IBOutlet weak var endTimeTextField: UITextField!
    
    @IBOutlet weak var problemTextView: UITextView!
    
    @IBOutlet weak var workContentTextView: UITextView!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
