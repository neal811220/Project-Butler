//
//  NewProjectTableViewCell.swift
//  Project Butler
//
//  Created by Neal on 2020/2/3.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

protocol NewProjectTableViewCellDelegate: AnyObject {
    
    func didSaveProject(projectName: String, workItem: String)
}

class NewProjectTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var leaderLabel: UILabel!
    
    @IBOutlet weak var projectNameTextField: UITextField!
    
    @IBOutlet weak var memberCollectionView: UICollectionView!
    
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    @IBOutlet weak var workItemTextField: UITextField!
    
    @IBOutlet weak var startDateTextField: UITextField!
    
    @IBOutlet weak var endDateTextField: UITextField!
    
    let nib = UINib(nibName: "MemberCollectionViewCell", bundle: nil)
    
    let colorNib = UINib(nibName: "ColorCollectionViewCell", bundle: nil)
    
    let colorCellContainerView: UIView = {
        
        let view = UIView()
        
        view.backgroundColor = UIColor.red
        
        view.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        
        return view
    }()
    
    weak var delegate: NewProjectTableViewCellDelegate?
    
    var passInputText: ((String) -> Void)?
    
    var memeberInfo: [FriendDetail] = [] {
        
        didSet {
            memberCollectionView.reloadData()
        }
    }
    
    var colorArray: [String] = []
    
    var transitionToMemberVC: ((NewProjectTableViewCell) -> Void)?
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.resignFirstResponder()
        
        guard let projectName = projectNameTextField.text, let workItem = workItemTextField.text else{
            return
        }
        
        delegate?.didSaveProject(projectName: projectName, workItem: workItem)
        
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
    
    func setupMemberCollectionView() {
        
        memberCollectionView.layer.shadowOpacity = 0.5
        
        memberCollectionView.layer.shadowOffset = CGSize(width: 3, height: 5)
        
        memberCollectionView.dataSource = self
        
        memberCollectionView.delegate = self
        
        memberCollectionView.register(nib, forCellWithReuseIdentifier: "MemberCell")
    }
    
    func setupColorCollectionView() {
        
        colorCollectionView.dataSource = self
        
        colorCollectionView.delegate = self
        
        colorCollectionView.register(colorNib, forCellWithReuseIdentifier: "ColorCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        setupMemberCollectionView()
        
        setupColorCollectionView()
    }
    
}

extension NewProjectTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            transitionToMemberVC?(self)

    }
}

extension NewProjectTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
            
        case memberCollectionView:
            
            if memeberInfo.count == 0 {
                
                return 1
                
            } else {
                
                return memeberInfo.count
                
            }
            
        case colorCollectionView:
            
            return 1
            
        default:
            
            return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == memberCollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberCell", for: indexPath) as? MemberCollectionViewCell else { return UICollectionViewCell() }
            
            if memeberInfo.count == 0 {
                
                cell.memberImage.image = UIImage.asset(.Icons_32px_AddMembers)
                
            } else {
                
                cell.memberImage.loadImage(memeberInfo[indexPath.row].userImageUrl, placeHolder: UIImage.asset(.Icons_128px_General))
                
            }
            
            return cell
            
        } else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as? ColorCollectionViewCell else { return UICollectionViewCell() }
            
            if colorArray.count == 0 {
                
                cell.colorImage.image = UIImage.asset(.Icons_64px_SelectColor)
                
            } else {
                
                cell.colorImage.loadImage(colorArray[indexPath.row])
            }
            
            return cell
            
        }
        
    }
    
}

extension NewProjectTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 30, height: 30)
        
    }
}
