//
//  MemberCollectionViewCell.swift
//  Project Butler
//
//  Created by Neal on 2020/2/13.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class MemberCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var memberImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        memberImage.layer.cornerRadius = 15
        // Initialization code
    }

}
