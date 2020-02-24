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
import AuthenticationServices

class LoginViewController: UIViewController, UITextFieldDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var userEmailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var appleIdSigninView: UIView!
    
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var googleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 28
        
        facebookButton.layer.cornerRadius = 20
        
        googleButton.layer.cornerRadius = 20
        
        userEmailTextField.delegate = self
        
        passwordTextField.delegate = self
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        GIDSignIn.sharedInstance()?.delegate = self
        
        setupSignInAppleButton()
        
        performExistingAccountSetupFlows()
        
    }
    
    @IBAction func pressedLoginButton(_ sender: UIButton) {
        
        if let email = userEmailTextField.text, let password = passwordTextField.text, email != "", password != ""{
            
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                
                guard error == nil else { return PBProgressHUD.showFailure(text:
                    "\(error!.localizedDescription)", viewController: self)}
                
                PBProgressHUD.showSuccess(text: "Sign up Success!", viewController: self)
                
                guard let userName = email.split(separator: "@").first else { return }
                
                let userImage = "Icons_32px_General"
                
                UserManager.shared.addGeneralUserData(name: String(userName), email: email, imageUrl: userImage)
                
                UserManager.shared.getLoginUserInfo()
                
                self.transitionToTabBar()
            }
            
        } else {
            
            PBProgressHUD.showFailure(text: "Input Worng!", viewController: self)
        }
        
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
                    
                    UserManager.shared.addSocialUserData()
                    
                    UserManager.shared.getLoginUserInfo()
                    
                   self.transitionToTabBar()
                    
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
    
    func transitionToTabBar() {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        guard let tabBarVC = UIStoryboard.main.instantiateViewController(withIdentifier: "TabBarVC") as? PBTabBarViewController else {
            return
        }
        
        delegate.window?.rootViewController = tabBarVC
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
            
            UserManager.shared.addSocialUserData()
            
            UserManager.shared.getLoginUserInfo()
            
            self.transitionToTabBar()
            
            print("Success!!")
        }
    }
    
    func setupSignInAppleButton() {
        
        let authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .whiteOutline)
        
        authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        
        authorizationButton.cornerRadius = 20
        
        authorizationButton.frame = appleIdSigninView.bounds
        
        appleIdSigninView.addSubview(authorizationButton)
        
    }
    
    @objc func handleAppleIdRequest() {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        let request = appleIDProvider.createRequest()
        
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        authorizationController.delegate = self
        
        authorizationController.presentationContextProvider = self
        
        authorizationController.performRequests()
        
    }
    
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return self.view.window!
    }
    
    private func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            
            let userIdentifier = appleIDCredential.user
            
            guard let givenName = appleIDCredential.fullName?.givenName, let email = appleIDCredential.email else {
                return
            }
            
            let familyName = appleIDCredential.fullName?.familyName
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            
            appleIDProvider.getCredentialState(forUserID: userIdentifier) { (credentialState, error) in
                switch credentialState {
                    
                case .authorized:
                    
                    // The Apple ID credential is valid. Show Home UI Here
                    
                    UserManager.shared.addAppleIDLoginUserDate(name: givenName, email: email, uid: userIdentifier, imageUrl: "Icons_128px_General")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                case .revoked:
                    // The Apple ID credential is revoked. Show SignIn UI Here.
                    break
                case .notFound:
                    // No credential was found. Show SignIn UI Here.
                    break
                default:
                    break
                }
            }
            
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            
            print(error)
            
        }
        
    }
}
