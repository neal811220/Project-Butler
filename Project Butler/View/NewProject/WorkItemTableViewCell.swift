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
        
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    var removeItem: ((WorkItemTableViewCell) -> Void)?
    
    @IBAction func pressedDelete(_ sender: UIButton) {
        
        removeItem?(self)
        
//        let remove = UIViewPropertyAnimator(duration: 1.0, curve: .easeIn) {
//            
//            self.leadingConstraint.isActive = false
//            
//            self.trailingConstraint.isActive = false
//            
//            self.trailingConstraint = self.workItemLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 400)
//            
//            self.leadingConstraint = self.workItemLabel.leadingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 10)
//            
//            self.leadingConstraint.isActive = true
//            
//            self.trailingConstraint.isActive = true
//        }
//        remove.startAnimation()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        workItemLabel.layer.borderWidth = 1
        workItemLabel.layer.borderColor = UIColor.lightGray.cgColor
        workItemLabel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        workItemLabel.layer.cornerRadius = 15
        workItemLabel.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
