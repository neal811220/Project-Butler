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

    @IBOutlet weak var signupEmail: UITextField!
    
    @IBOutlet weak var signupPassword: UITextField!
    
    @IBOutlet weak var signupConfirmPassword: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signupButton.layer.cornerRadius = 28
        
        signupEmail.delegate = self
        
        signupPassword.delegate = self
        
        signupConfirmPassword.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressedSignup(_ sender: UIButton) {
        
        if let email = signupEmail.text, let password = signupPassword.text, let confirm = signupConfirmPassword.text, email != "", password != "", confirm != "" {
            
            if password == confirm {
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    
                    guard error == nil else { return PBProgressHUD.showFailure(text:
                        "\(error!.localizedDescription)", viewController: self)}
                    
                    PBProgressHUD.showSuccess(text: "Sign up Success!", viewController: self)
                    
                    let userImage = "Icons_32px_ Visitors"
                    
                    let userName = email.split(separator: "@")
                    
                    UserManager.shared.addUserData(name: String(userName.first!), email: email, imageUrl: userImage)
                    
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
    @IBAction func skip(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
           textField.resignFirstResponder()
        
           return true
       }
       
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           
           self.view.endEditing(true)
       }
    
}
