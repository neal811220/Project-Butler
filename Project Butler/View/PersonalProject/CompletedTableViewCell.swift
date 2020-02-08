//
//  CompletedTableViewCell.swift
//  Project Butler
//
//  Created by Neal on 2020/2/8.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class CompletedTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var leaderImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var completedImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var completionDataLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var completionHourLable: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.shadowOpacity = 0.5
        backView.layer.shadowOffset = CGSize(width: 0, height: 3)
        backView.layer.cornerRadius = 20
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
