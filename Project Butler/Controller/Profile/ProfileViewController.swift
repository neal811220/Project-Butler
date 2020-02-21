//
//  ProfileViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/1/31.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var titleBackgroundView: UIView!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userEmail: UILabel!
    
    @IBAction func changePassword(_ sender: UIButton) {
        
        updatePasswordAlert()
    }
    
    @IBAction func login(_ sender: UIButton) {
        
        guard let loginVC = UIStoryboard.login.instantiateViewController(identifier: "LoginPage") as? LoginViewController else { return }
        present(loginVC, animated: true, completion: nil)
    }
    
    @IBAction func Logout(_ sender: UIButton) {
        do {
            
            let delegate = UIApplication.shared.delegate as! AppDelegate
            
            let tabbarVC = UIStoryboard.main.instantiateViewController(identifier: "TabBarVC") as? PBTabBarViewController
            try Auth.auth().signOut()
            
            delegate.window?.rootViewController = tabbarVC
            
        } catch {
            
            print("Error")
            
        }
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        userName.text = UserDefaults.standard.value(forKey: "userName") as? String
        
        userEmail.text = UserDefaults.standard.value(forKey: "userEmail") as? String
        
        userImage.loadImage(CurrentUserInfo.shared.userImageUrl, placeHolder: UIImage.asset(.Icons_128px_General))
        
//        userImage.image = UIImage.asset(.Icons_128px_General)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        
        titleBackgroundView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        titleBackgroundView.layer.cornerRadius = titleBackgroundView.frame.width / 2
        
        userImage.layer.cornerRadius = userImage.frame.width / 2
        
        userImage.layer.borderWidth = 2
        
        userImage.layer.borderColor = UIColor.white.cgColor
    }
    
    func updatePasswordAlert() {
        
        let alert = UIAlertController(title: "ChangePassword", message: "Please Enter New Password To Change", preferredStyle: .alert)
        
        alert.addTextField()
        
        alert.addTextField()
        
        alert.textFields![0].placeholder = "Enter Old Password"
        
        alert.textFields![0].keyboardType = .default
        
        alert.textFields![0].isSecureTextEntry = true
        
        alert.textFields![1].placeholder = "Enter New password"
        
        alert.textFields![1].keyboardType = .default
        
        alert.textFields![1].isSecureTextEntry = true
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            guard let oldPassword = alert.textFields![0].text else {
                return
            }
            
            guard let newPassword = alert.textFields![1].text else {
                return
            }
            
            guard let user = Auth.auth().currentUser else {
                return
            }
            
            guard let email = user.email else {
                
                return
            }
            
            let credential: AuthCredential = EmailAuthProvider.credential(withEmail: email, password: oldPassword)
            
            user.reauthenticate(with: credential, completion: { (result, error) in
                
                if let error = error {
                    
                    PBProgressHUD.showFailure(text: "Old Password Wrong", viewController: self)
                    
                    print(error)
                    
                } else{
                    
                    Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (error) in
                        
                        if let error = error {
                            
                            
                            print(error.localizedDescription)
                            
                        } else {
                            
                            PBProgressHUD.showSuccess(text: "Password Change Success", viewController: self)
                            
                            print("Success Change Password")
                            
                        }
                        
                    })
                }
            })
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
}
