//
//  NewProjectTableViewCell.swift
//  Project Butler
//
//  Created by Neal on 2020/2/3.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class NewProjectTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var leaderLabel: UILabel!
    
    @IBOutlet weak var projectNameTextField: UITextField!
    
    @IBOutlet weak var memberCollectionView: UICollectionView!
    
    @IBOutlet weak var workItemTextField: UITextField!
    
    @IBOutlet weak var startDateTextField: UITextField!
    
    @IBOutlet weak var endDateTextField: UITextField!
    
    let nib = UINib(nibName: "MemberCollectionViewCell", bundle: nil)
    
    var passInputText: ((String) -> Void)?
    
    var passProjectName: ((String) -> Void)?
    
    var memeberInfo: [FriendDetail] = [] {
        
        didSet {
            memberCollectionView.reloadData()
        }
    }
    
    var transitionToMemberVC: ((NewProjectTableViewCell) -> Void)?
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.resignFirstResponder()
        
        passProjectName?(projectNameTextField.text ?? "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func pressedAddButton(_ sender: UIButton) {
        
        guard let inputText = workItemTextField.text else {
            return
        }
        
        passInputText?(inputText)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        projectNameTextField.delegate = self
        
        workItemTextField.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        memberCollectionView.layer.shadowOpacity = 0.5
        
        memberCollectionView.layer.shadowOffset = CGSize(width: 3, height: 5)
        
        memberCollectionView.dataSource = self
        
        memberCollectionView.delegate = self 
        
        memberCollectionView.register(nib, forCellWithReuseIdentifier: "MemberCell")
        
        // Configure the view for the selected state
    }
    
}

extension NewProjectTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        transitionToMemberVC?(self)
        
    }
}

extension NewProjectTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if memeberInfo.count == 0 {
            
            return 1
            
        } else {
            
            return memeberInfo.count
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberCell", for: indexPath) as? MemberCollectionViewCell else { return UICollectionViewCell() }
        
        if memeberInfo.count == 0 {
            
            cell.memberImage.image = UIImage.asset(.Icons_32px_AddMembers)
            
        } else {
            
            cell.memberImage.loadImage(memeberInfo[indexPath.row].userImageUrl, placeHolder: UIImage.asset(.Icons_128px_General))
            
        }
                
        return cell
        
    }
    
}

extension NewProjectTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 30, height: 30)
        
    }
}
