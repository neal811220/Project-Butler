//
//  FriendListTableViewCell.swift
//  Project Butler
//
//  Created by Neal on 2020/2/1.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

@objc protocol FriendListTableViewCellDelegate: AnyObject {
    
    func passIndexPath(_ friendListTableViewCell: FriendListTableViewCell)
}

class FriendListTableViewCell: UITableViewCell {

    @IBOutlet weak var whitLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var friendImage: UIImageView!
    
    @IBOutlet weak var friendTitle: UILabel!
    
    @IBOutlet weak var friendEmail: UILabel!
    
    @IBOutlet weak var rightButton: UIButton!
    
    weak var delegate: FriendListTableViewCellDelegate?
    
    @IBAction func pressedRightbutton(_ sender: UIButton) {
        
        delegate?.passIndexPath(self)
    }
    @IBAction func pressedLeftButton(_ sender: UIButton) {
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        friendImage.layer.cornerRadius  = friendImage.frame.width / 2
        
        whitLabel.layer.cornerRadius = 10
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
