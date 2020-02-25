//
//  SignupTableViewCell.swift
//  Project Butler
//
//  Created by Neal on 2020/2/25.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

protocol SignupTableViewCellDelegate: AnyObject {
    
    func passInputText(email: String, password: String, confirmPassword: String)
}

class SignupTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var skipButton: UIButton!
    
    weak var delegate: SignupTableViewCellDelegate?
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let confirm = confirmPasswordTextField.text else {
            return
        }
        
        delegate?.passInputText(email: email, password: password, confirmPassword: confirm)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        emailTextField.delegate = self
        
        passwordTextField.delegate = self
        
        confirmPasswordTextField.delegate = self
        
        signupButton.layer.cornerRadius = 28
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
