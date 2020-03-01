//
//  WorkLogCollectionViewCell.swift
//  Project Butler
//
//  Created by Neal on 2020/2/15.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class WorkLogCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var memberImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        memberImage.layer.cornerRadius = 15
        
        // Initialization code
    }

}
