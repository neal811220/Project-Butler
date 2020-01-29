//
//  RegisterViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/1/24.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class SignupViewController: UIViewController {

    @IBOutlet weak var signupEmail: UITextField!
    @IBOutlet weak var signupPassword: UITextField!
    @IBOutlet weak var signupConfirmPassword: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupButton.layer.cornerRadius = 28
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressedSignup(_ sender: UIButton) {
        
        if let email = signupEmail.text, let password = signupPassword.text, let confirm = signupConfirmPassword.text, email != "", password != "", confirm != "" {
            if password == confirm {
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    guard error == nil else { return self.errorHUD(text: "\(error!.localizedDescription)")}
                    self.successHUD(text: "Signup Success!")
                }
            } else{
                self.errorHUD(text: "Password not match!")
            }
        } else {
            self.errorHUD(text: "Input Wrong!")
        }
    }
    @IBAction func skip(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func successHUD(text: String) {
        
        let hud = JGProgressHUD(style: .dark)
        
        hud.textLabel.text = text
        
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        
        hud.show(in: self.view, animated: true)
        
        hud.dismiss(afterDelay: 2)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func errorHUD(text: String) {
        
        let hud = JGProgressHUD(style: .dark)
        
        hud.textLabel.text = text
        
        hud.indicatorView = JGProgressHUDErrorIndicatorView()
        
        hud.show(in: self.view, animated: true)
        
        hud.dismiss(afterDelay: 2.0)
        
    }
    
}
