//
//  ResetPasswordTableViewCell.swift
//  Project Butler
//
//  Created by Neal on 2020/2/25.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

protocol ResetPasswordTableViewCellDelegate: AnyObject {
    
    func passInputText(email: String)
}

class ResetPasswordTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var skipButton: UIButton!
    
    weak var delegate: ResetPasswordTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        resetButton.layer.cornerRadius = 28
        
        emailTextField.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let email = emailTextField.text else {
            return
        }
        
        delegate?.passInputText(email: email)
    }
    
}
