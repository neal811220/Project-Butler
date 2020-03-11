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
    
    var didTaptransitionsToPrivacyPolicyVC: (() -> Void)?
    
    let privacyPolicyButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle("Privacy Policy", for: .normal)
        
        button.setTitleColor(UIColor.B2, for: .normal)
        
        button.titleLabel?.font = UIFont(name: "AmericanTypewriter-Bold", size: 14)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
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
        
        setupPrivacyPolicyButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupPrivacyPolicyButton() {
        
        contentView.addSubview(privacyPolicyButton)
                
        NSLayoutConstraint.activate([
            
            privacyPolicyButton.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 5),
            
            privacyPolicyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            privacyPolicyButton.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            
            privacyPolicyButton.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
        
        privacyPolicyButton.addTarget(self, action: #selector(transitionsToPrivacyPolicyVC), for: .touchUpInside)
    }
    
    @objc func transitionsToPrivacyPolicyVC() {
        
        didTaptransitionsToPrivacyPolicyVC?()
    }
}
