//
//  NewProjectTableViewCell.swift
//  Project Butler
//
//  Created by Neal on 2020/2/3.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class NewProjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var leftImageView: UIImageView!
    
    @IBOutlet weak var inputContentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.layer.borderWidth = 1
        titleLabel.layer.borderColor = UIColor.gray.cgColor
        titleLabel.layer.cornerRadius = 10
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
