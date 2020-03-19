//
//  NewProjectTableViewCell.swift
//  Project Butler
//
//  Created by Neal on 2020/2/3.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

protocol NewProjectTableViewCellDelegate: AnyObject {
    
    func didSaveProject(_ newProjectTableViewCell: NewProjectTableViewCell, projectName: String, workItem: String)
    
    func passColor(_ newProjectTableViewCell: NewProjectTableViewCell, color: String)
}

class NewProjectTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var colorTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leaderLabel: UILabel!
    
    @IBOutlet weak var projectNameTextField: UITextField!
    
    @IBOutlet weak var memberCollectionView: UICollectionView!
    
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    @IBOutlet weak var workItemTextField: UITextField!
    
    @IBOutlet weak var startDateTextField: UITextField!
    
    @IBOutlet weak var endDateTextField: UITextField!
    
    let nib = UINib(nibName: "MemberCollectionViewCell", bundle: nil)
    
    let numberNib = UINib(nibName: "NumberCollectionViewCell", bundle: nil)
    
    let colorNib = UINib(nibName: "ColorCollectionViewCell", bundle: nil)
    
    let colorCellContainerView: UIView = {
        
        let view = UIView()
        
        view.backgroundColor = UIColor.red
        
        view.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        
        return view
    }()
    
    weak var delegate: NewProjectTableViewCellDelegate?
    
    var passInputText: ((String) -> Void)?
    
    var selectImage = "" {
        
        didSet {
            
            delegate?.passColor(self, color: selectImage)
            
        }
    }
    
    var didSelect = false
    
    var memeberInfo: [FriendDetail] = [] {
        
        didSet {
            
            if memeberInfo.count == 0 {
                
                selectImage = ""
                
            }
            
            colorCollectionView.reloadData()
            
            memberCollectionView.reloadData()
        }
    }
    
    var colorArray: [String] = ["Icons_64px_SelectColor", "BCB2", "BCG3", "BCR1"]
    
    var transitionToMemberVC: ((NewProjectTableViewCell) -> Void)?
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.resignFirstResponder()
        
        guard let projectName = projectNameTextField.text, let workItem = workItemTextField.text else {
            return
        }
        
        delegate?.didSaveProject(self, projectName: projectName, workItem: workItem)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func pressedAddButton(_ sender: UIButton) {
        
        guard let inputText = workItemTextField.text else {
            return
        }
        
        if inputText != "" {
            
            passInputText?(inputText)
        }
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
        
        memberCollectionView.register(numberNib, forCellWithReuseIdentifier: "NumberCell")
    }
    
    func setupColorCollectionView() {
        
        colorCollectionView.dataSource = self
        
        colorCollectionView.delegate = self
        
        colorCollectionView.register(colorNib, forCellWithReuseIdentifier: "ColorCell")
    }
    
    func setupColorTrailing() {
        
        UIView.animate(withDuration: 0.3) {
            
            if self.didSelect {
                
                self.colorTrailingConstraint.constant = 30
                
            } else {
                
                self.colorTrailingConstraint.constant = 262
                
            }
            
            self.layoutIfNeeded()
            
            self.colorCollectionView.reloadData()
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        setupMemberCollectionView()
        
        setupColorCollectionView()
    }
    
}

extension NewProjectTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == memberCollectionView {
            
            transitionToMemberVC?(self)
            
        } else {
            
            didSelect = true
            
            if indexPath.row != 0 {
                
                selectImage = colorArray[indexPath.row]
                
                didSelect = false
                
            } else {
                
            }
            
            setupColorTrailing()
        }
    }
}

extension NewProjectTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
            
        case memberCollectionView:
            
            if memeberInfo.count == 0 {
                
                return 1
                
            } else if memeberInfo.count <= 3 {
                
                return memeberInfo.count
                
            } else {
                
                return 4
            }
            
        case colorCollectionView:
            
            if didSelect {
                
                return 4
                
            } else {
                
                return 1
            }
            
        default:
            
            return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == memberCollectionView {
            
            if memeberInfo.count == 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberCell", for: indexPath) as? MemberCollectionViewCell else { return UICollectionViewCell() }
                cell.memberImage.layer.cornerRadius = 0
                cell.memberImage.image = UIImage.asset(.Icons_32px_AddMembers)
                
                return cell
                
            } else if indexPath.row == 3 {
                
                 guard let numberCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumberCell", for: indexPath) as? NumberCollectionViewCell else { return UICollectionViewCell() }
                numberCell.numberLabel.text = "+\(memeberInfo.count - 3)"
                
                return numberCell
                
            } else {
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberCell", for: indexPath) as? MemberCollectionViewCell else { return UICollectionViewCell() }
                cell.memberImage.layer.cornerRadius = 15
                cell.memberImage.loadImage(memeberInfo[indexPath.row].userImageUrl, placeHolder: UIImage.asset(.Icons_128px_General))
                
                return cell
            }
            
        } else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as? ColorCollectionViewCell else { return UICollectionViewCell() }
            
            if selectImage == "" && didSelect == false {
                
                cell.colorImage.image = UIImage.asset(.Icons_64px_SelectColor)
                
            } else if didSelect {
                
                cell.colorImage.image = UIImage(named: colorArray[indexPath.row])
                
            } else {
                
                cell.colorImage.image = UIImage(named: selectImage)
                
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
