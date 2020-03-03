//
//  LoginTableViewCell.swift
//  Project Butler
//
//  Created by Neal on 2020/2/24.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

protocol LoginTableViewCellDelegate: AnyObject {
    
    func passInputText(_ loginTableViewCell: LoginTableViewCell, email: String, password: String)
}

class LoginTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var userEmailTextField: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var appleLoginView: UIView!
    
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var googleButton: UIButton!
    
    weak var delegate: LoginTableViewCellDelegate?
    
    @IBAction func pressedLogin(_ sender: UIButton) {
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let email = userEmailTextField.text, let password = userPasswordTextField.text else {
            
            return
        }
        
        delegate?.passInputText(self, email: email, password: password)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userEmailTextField.delegate = self
        
        userPasswordTextField.delegate = self
        
        loginButton.layer.cornerRadius = 28
        
        googleButton.layer.cornerRadius = 28
        
        facebookButton.layer.cornerRadius = 28
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
