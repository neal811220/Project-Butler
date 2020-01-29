//
//  LoginViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/1/24.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit
import FacebookLogin
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userEmailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var appleIdButton: UIButton!
    
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var googleButton: UIButton!
    
    override func viewDidLoad() {
           super.viewDidLoad()
           
           loginButton.layer.cornerRadius = 28
           
           appleIdButton.layer.cornerRadius = 20
           
           facebookButton.layer.cornerRadius = 20
           
           googleButton.layer.cornerRadius = 20
           // Do any additional setup after loading the view.
       }
    
    @IBAction func signupButton(_ sender: UIButton) {
        
    }
    
    @IBAction func pressedLoginButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedAppleLogin(_ sender: UIButton) {
    }
    
    @IBAction func pressedFacebookLogin(_ sender: UIButton) {
        
        let manager = LoginManager()
        
        manager.logIn(permissions: [.email], viewController: self) { (result) in
            
            if case LoginResult.success(granted: _, declined: _, token: _) = result {
                
                guard let tokenString = AccessToken.current?.tokenString else { return }
                
                let credential = FacebookAuthProvider.credential(withAccessToken: tokenString)
                
                Auth.auth().signIn(with: credential) { [weak self] (result, error) in
                    
                    guard let self = self else { return }
                    
                    guard error == nil else {
                        
                        print(error?.localizedDescription)
                        
                        return
                    }
                    
                    self.dismiss(animated: true, completion: nil)
                    
                    print("FBLogin Success")
                }
            } else {
                print("login fail")
            }
        }
    }
    
    @IBAction func pressedGoogleLogin(_ sender: UIButton) {
        
    }
    
}
