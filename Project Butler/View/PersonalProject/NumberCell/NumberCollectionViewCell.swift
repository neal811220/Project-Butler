//
//  NumberTableViewCell.swift
//  Project Butler
//
//  Created by Neal on 2020/2/15.
//  Copyright © 2020 neal812220. All rights reserved.
//

import Foundation
import UIKit

class NumberCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    
    override func awakeFromNib() {
        
        numberLabel.layer.borderWidth = 1
        
        numberLabel.layer.borderColor = UIColor.B1?.cgColor
        
        numberLabel.backgroundColor = UIColor.B1
        
        numberLabel.clipsToBounds = true
        
        numberLabel.layer.cornerRadius = 15
    }
}
