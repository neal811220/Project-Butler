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
import GoogleSignIn

class LoginViewController: UIViewController, UITextFieldDelegate, GIDSignInDelegate {
    
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
        
        userEmailTextField.delegate = self
        
        passwordTextField.delegate = self
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        GIDSignIn.sharedInstance()?.delegate = self
        
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
                        
                        print(error!.localizedDescription)
                        
                        return
                    }
                    
                    self.dismiss(animated: true, completion: nil)
                    
                    guard let userName = Auth.auth().currentUser?.displayName, let userEmail = Auth.auth().currentUser?.email, let userImage = Auth.auth().currentUser?.photoURL?.absoluteString else { return }

                    
                    UserManager.shared.addUserData(name: userName, email: userEmail, imageUrl: userImage)
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                    print("FBLogin Success")
                }
            } else {
                print("login fail")
            }
        }
    }
    
    @IBAction func pressedGoogleLogin(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
           
           if let error = error {
               print(error.localizedDescription)
               return
           }
           
           guard let authentication = user.authentication else { return }
       
           let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
           
           Auth.auth().signIn(with: credential) { (result, error) in
               if let error = error {
                   print(error.localizedDescription)
               }
               
               guard let userName = Auth.auth().currentUser?.displayName, let userEmail = Auth.auth().currentUser?.email, let userImage = Auth.auth().currentUser?.photoURL?.absoluteString else { return }
               
               UserManager.shared.addUserData(name: userName, email: userEmail, imageUrl: userImage)
               
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                self.dismiss(animated: true, completion: nil)
            }
                
               print("Success!!")
           }
       }
    
}
