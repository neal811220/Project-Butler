//
//  PersonalProcessingTableViewCell.swift
//  Project Butler
//
//  Created by Neal on 2020/2/8.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class ProcessingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var hourLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let nib = UINib(nibName: "ProcessingCollectionViewCell", bundle: nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backView.layer.shadowOpacity = 0.5
        
        backView.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        backView.layer.cornerRadius = 20
        
        collectionView.delegate = self
        
        collectionView.dataSource = self
        
        collectionView.register(nib, forCellWithReuseIdentifier: "ProcessingCell")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ProcessingTableViewCell: UICollectionViewDelegate {
    
}

extension ProcessingTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProcessingCell", for: indexPath) as? ProcessingCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    
    
}

extension ProcessingTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
}
