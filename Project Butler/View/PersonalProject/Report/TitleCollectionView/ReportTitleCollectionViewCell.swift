//
//  ReportTitleCollectionViewCell.swift
//  Project Butler
//
//  Created by Neal on 2020/2/19.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class ReportTitleCollectionViewCell: UICollectionViewCell {
    
    var titleButtonIndexPath: (() -> Void)?
    
    @IBOutlet weak var titleButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func pressedTitleButton(_ sender: UIButton) {
        
//        sender.isSelected.toggle()
        
        titleButtonIndexPath?()
    }
    
}
