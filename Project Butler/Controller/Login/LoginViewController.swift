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

class LoginViewController: UIViewController, GIDSignInDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var emailText = ""
    
    var passwordText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.dataSource = self
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        GIDSignIn.sharedInstance()?.delegate = self
        
        setupSignInAppleButton()
        
        performExistingAccountSetupFlows()
        
    }
    
     @objc func pressedLoginButton(_ sender: UIButton) {
        
        view.endEditing(true)
        
        if emailText != "", passwordText != "" {
            
            Auth.auth().signIn(withEmail: emailText, password: passwordText) { [weak self] (result, error) in
                guard let strongSelf = self else {
                    return
                }
                guard error == nil else { return PBProgressHUD.showFailure(text:
                    "\(error!.localizedDescription)", viewController: strongSelf)}
                
                PBProgressHUD.showSuccess(text: "Sign up Success!", viewController: strongSelf)
                
                guard let userName = strongSelf.emailText.split(separator: "@").first else { return }
                
                let userImage = "Icons_32px_General"
                
                UserManager.shared.addGeneralUserData(name: String(userName), email: strongSelf.emailText, imageUrl: userImage)
                
                UserManager.shared.getLoginUserInfo()
                
                strongSelf.transitionToTabBar()
            }
            
        } else {
            
            PBProgressHUD.showFailure(text: "Input Worng!", viewController: self)
        }
        
    }
    
    @objc func pressedFacebookLogin(_ sender: UIButton) {
        
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
    
    @objc func pressedGoogleLogin(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance().signIn()
        
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

extension LoginViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoginCell", for: indexPath) as? LoginTableViewCell else{
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        cell.facebookButton.addTarget(self, action: #selector(pressedFacebookLogin), for: .touchUpInside)
        
        cell.googleButton.addTarget(self, action: #selector(pressedGoogleLogin), for: .touchUpInside)
        
        cell.loginButton.addTarget(self, action: #selector(pressedLoginButton), for: .touchUpInside)
        
        let authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .whiteOutline)
        
        authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        
        authorizationButton.cornerRadius = 20
        
        authorizationButton.frame = cell.appleLoginView.bounds
        
        cell.appleLoginView.addSubview(authorizationButton)
        
        return cell
    }
    
    
}

extension LoginViewController: LoginTableViewCellDelegate {
    
    func passInputText(email: String, password: String) {
        
        self.emailText = email
        
        self.passwordText = password
        
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
