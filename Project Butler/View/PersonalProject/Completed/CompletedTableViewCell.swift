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
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var completionDateLabel: UILabel!
    
    @IBOutlet weak var hourLabel: UILabel!
    
    @IBOutlet weak var completionHourLable: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let nib = UINib(nibName: "CompletedCollectionViewCell", bundle: nil)
    
    let numberNib = UINib(nibName: "NumberCollectionViewCell", bundle: nil)
    
    var layout = UICollectionViewFlowLayout()
    
    var members: [AuthInfo] = [] {
        
        didSet {
            
            collectionView.reloadData()
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        backView.layer.shadowOpacity = 0.5
        
        backView.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        backView.layer.cornerRadius = 20
        
        collectionView.delegate = self
        
        collectionView.dataSource = self
        
        collectionView.register(nib, forCellWithReuseIdentifier: "CompletedCell")
        
        collectionView.register(numberNib, forCellWithReuseIdentifier: "NumberCell")
        
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension CompletedTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if members.count <= 5 {
            
            return members.count
            
        } else {
            
            return 5
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 4 {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumberCell", for: indexPath) as? NumberCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.numberLabel.text = "+\(members.count - 4)"
            
            return cell
            
        } else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompletedCell", for: indexPath) as? CompletedCollectionViewCell else { return UICollectionViewCell() }
            
            cell.memberImage.loadImage(members[indexPath.row].userImageUrl, placeHolder: UIImage.asset(.Icons_128px_General))
            
            return cell
        }
        
    }
    
}

extension CompletedTableViewCell: UICollectionViewDelegate {
    
}

extension CompletedTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
}
