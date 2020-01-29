//
//  LoginViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/1/24.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var appleIdButton: UIButton!
    
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var googleButton: UIButton!
    
    @IBAction func signupButton(_ sender: UIButton) {
        
    }
    
    @IBAction func pressedLoginButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedAppleLogin(_ sender: UIButton) {
    }
    
    @IBAction func pressedFacebookLogin(_ sender: UIButton) {
    }
    
    @IBAction func pressedGoogleLogin(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = 28
        
        appleIdButton.layer.cornerRadius = 20
        
        facebookButton.layer.cornerRadius = 20
        
        googleButton.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
    }

}
