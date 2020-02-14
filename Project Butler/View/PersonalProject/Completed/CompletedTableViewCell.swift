//
//  CompletedTableViewCell.swift
//  Project Butler
//
//  Created by Neal on 2020/2/8.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class CompletedTableViewCell: UITableViewCell {

    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var leaderImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var completedImage: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var completionDataLabel: UILabel!
    
    @IBOutlet weak var hourLabel: UILabel!
    
    @IBOutlet weak var completionHourLable: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let nib = UINib(nibName: "CompletedCollectionViewCell", bundle: nil)
    
    var layout = UICollectionViewFlowLayout()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        backImage.layer.shadowOpacity = 0.5
        
        backImage.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        backImage.layer.cornerRadius = 20
        
        collectionView.delegate = self
        
        collectionView.dataSource = self
        
        collectionView.register(nib, forCellWithReuseIdentifier: "CompletedCell")
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CompletedTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompletedCell", for: indexPath) as? CompletedCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
}

extension CompletedTableViewCell: UICollectionViewDelegate {
    
}

extension CompletedTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
}
