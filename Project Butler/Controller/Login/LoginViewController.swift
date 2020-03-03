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
    
    var allUser: [AuthInfo] = []
    
    var activityView = UIActivityIndicatorView()
    
    var fbLoginGroup = DispatchGroup()
    
    var googleLoginGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        GIDSignIn.sharedInstance()?.delegate = self
        
        performExistingAccountSetupFlows()
        
        setupActivityView()
    }
    
    @objc func pressedLoginButton(_ sender: UIButton) {
        
        view.endEditing(true)
        
        if emailText != "", passwordText != "" {
            
            Auth.auth().signIn(withEmail: emailText, password: passwordText) { [weak self] (result, error) in
                
                guard let strongSelf = self else {
                    
                    return
                }
                
                guard let uid = Auth.auth().currentUser?.uid else {
                    
                    return PBProgressHUD.showFailure(text:
                        "\(error!.localizedDescription)", viewController: strongSelf)
                }
                
                guard error == nil else {
                    return PBProgressHUD.showFailure(text:
                        "\(error!.localizedDescription)", viewController: strongSelf)
                }
                
                UserDefaults.standard.set(uid, forKey: "userID")
                
                strongSelf.activityView.startAnimating()
                
                CurrentUserInfo.shared.getLoginUserInfo(uid: uid) { (result) in
                    
                    switch result {
                        
                    case .success:
                        
                        print("Success")
                        
                    case .failure(let error):
                        
                        print(error)
                    }
                    
                    strongSelf.activityView.stopAnimating()
                }
                
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
                    
                    guard let strongSelf = self, let uid = Auth.auth().currentUser?.uid else { return }
                    
                    guard error == nil else {
                        
                        print(error!.localizedDescription)
                        
                        return
                        
                    }
                    
                    UserDefaults.standard.set(uid, forKey: "userID")
                    
                    strongSelf.fbLoginGroup.enter()
                    
                    UserManager.shared.fetchAllUser { [weak self] (result) in
                        
                        strongSelf.activityView.startAnimating()
                        
                        guard let strongSelf = self else {
                            return
                        }
                        
                        switch result {
                            
                        case .success(let data):
                            
                            strongSelf.allUser = data
                            
                        case .failure(let error):
                            
                            print(error)
                        }
                        
                        strongSelf.fbLoginGroup.leave()
                    }
                    
                    
                    strongSelf.fbLoginGroup.notify(queue: DispatchQueue.main) {
                        
                        let match = strongSelf.allUser.filter({ $0.userID == uid })
                        
                        if match.isEmpty {
                            
                            UserManager.shared.addSocialUserData()
                            
                        } else {
                            
                            strongSelf.activityView.startAnimating()
                            
                            CurrentUserInfo.shared.getLoginUserInfo(uid: uid) { (result) in
                                
                                switch result {
                                    
                                case .success:
                                    
                                    print("Success")
                                    
                                case .failure(let error):
                                    
                                    print(error)
                                }
                                
                                strongSelf.activityView.stopAnimating()
                            }
                        }
                        
                        strongSelf.transitionToTabBar()
                    }
                    
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
        DispatchQueue.main.async {
            
            let delegate = UIApplication.shared.delegate as! AppDelegate
            
            guard let tabBarVC = UIStoryboard.main.instantiateViewController(withIdentifier: "TabBarVC") as? PBTabBarViewController else {
                return
            }
            
            delegate.window?.rootViewController = tabBarVC
        }
        
    }
    
    func setupActivityView() {
        
        view.addSubview(activityView)
        
        NSLayoutConstraint.activate([
            
            activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            activityView.heightAnchor.constraint(equalToConstant: view.frame.size.width / 10),
            
            activityView.widthAnchor.constraint(equalToConstant: view.frame.size.width / 10)
        ])
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
        
        Auth.auth().signIn(with: credential) {  [weak self] (result, error) in
            
            guard error == nil else {
                
                print(error!.localizedDescription)
                
                return
            }
            
            guard let strongSelf = self, let uid = Auth.auth().currentUser?.uid else {
                return
                
            }
            
            UserDefaults.standard.set(uid, forKey: "userID")
            
            strongSelf.googleLoginGroup.enter()
            
            UserManager.shared.fetchAllUser { [weak self] (result) in
                
                strongSelf.activityView.startAnimating()
                
                guard let strongSelf = self else {
                    return
                }
                
                switch result {
                    
                case .success(let data):
                    
                    strongSelf.allUser = data
                    
                case .failure(let error):
                    
                    print(error)
                }
                
                strongSelf.googleLoginGroup.leave()
            }
            
            
            strongSelf.googleLoginGroup.notify(queue: DispatchQueue.main) {
                
                let match = strongSelf.allUser.filter({ $0.userID == uid })
                
                if match.isEmpty {
                    
                    UserManager.shared.addSocialUserData()
                    
                } else {
                    
                    strongSelf.activityView.startAnimating()
                    
                    CurrentUserInfo.shared.getLoginUserInfo(uid: uid) { (result) in
                        
                        switch result {
                            
                        case .success:
                            
                            print("Success")
                            
                        case .failure(let error):
                            
                            print(error)
                        }
                        
                        strongSelf.activityView.stopAnimating()
                    }
                }
                
                strongSelf.transitionToTabBar()
            }
        }
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
    
    func passInputText(_ loginTableViewCell: LoginTableViewCell, email: String, password: String) {
        
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
            
            let firstName = appleIDCredential.fullName?.givenName
            
            let familyName = appleIDCredential.fullName?.familyName
            
            let email = appleIDCredential.email
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            
            appleIDProvider.getCredentialState(forUserID: userIdentifier) { [weak self] (credentialState, error) in
                
                guard let strongSelf = self else {
                    return
                }
                
                switch credentialState {
                    
                case .authorized:
                    print("TEST")
                    // The Apple ID credential is valid. Show Home UI Here
                    if firstName == nil || familyName == nil || email == nil {
                        
                        strongSelf.activityView.startAnimating()
                        
                        CurrentUserInfo.shared.getLoginUserInfo(uid: userIdentifier) { (result) in
                            
                            switch result {
                                
                            case .success:
                                
                                print("Success")
                                
                            case .failure(let error):
                                
                                print(error)
                            }
                            
                            strongSelf.activityView.stopAnimating()
                        }
                        
                    } else {
                        
                        guard let image = UIImage(named: "Icons_128px_General") else {
                            
                            return
                        }
                        
                        UserManager.shared.addGeneralUserData(name: firstName! + familyName!, email: email!, imageUrl: image, uid: userIdentifier)
                        
                        UserDefaults.standard.set(userIdentifier, forKey: "userID")
                    }
                    
                    strongSelf.transitionToTabBar()
                    
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
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        print(error)
        
    }
    
}
