//
//  RegisterViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/1/24.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
        
    var emailText = ""
    
    var passwordText = ""
    
    var confirmtext = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @objc func pressedSignup(_ sender: UIButton) {
        
        view.endEditing(true)
        
        if emailText != "", passwordText != "", confirmtext != "" {
            
            if passwordText == confirmtext {
                
                Auth.auth().createUser(withEmail: emailText, password: passwordText) { (result, error) in
                    
                    guard error == nil else { return PBProgressHUD.showFailure(text:
                        "\(error!.localizedDescription)", viewController: self)}
                    
                    PBProgressHUD.showSuccess(text: "Sign up Success!", viewController: self)
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } else{
                
                PBProgressHUD.showFailure(text: "Password Not Match!", viewController: self)
            }
        } else {
            
            PBProgressHUD.showFailure(text: "Input Worng!", viewController: self)
        }
    }
    
    @objc func skip(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
}

extension SignupViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SignupCell", for: indexPath) as? SignupTableViewCell else{
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        cell.signupButton.addTarget(self, action: #selector(pressedSignup), for: .touchUpInside)
        
        cell.skipButton.addTarget(self, action: #selector(skip), for: .touchUpInside)
        return cell
    }
}


extension SignupViewController: SignupTableViewCellDelegate {
    
    func passInputText(email: String, password: String, confirmPassword: String) {
        
        self.emailText = email
        
        self.passwordText = password
        
        self.confirmtext = confirmPassword
    }
    
}
