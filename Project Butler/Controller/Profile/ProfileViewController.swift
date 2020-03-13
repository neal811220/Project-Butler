//
//  ProfileViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/1/31.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit
import Firebase
import FacebookLogin

class ProfileViewController: UIViewController {
        
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var titleBackgroundView: UIView!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userEmail: UILabel!
    
    let imagePickerController = UIImagePickerController()
    
    @IBAction func changePassword(_ sender: UIButton) {
        
        updatePasswordAlert()
        
    }
    
    @IBAction func logout(_ sender: UIButton) {
        
        do {
            
            let manager = LoginManager()
            
            guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
                
                return
            }
            
            let loginVC = UIStoryboard.login.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController
            
            try Auth.auth().signOut()
            
            manager.logOut()
            
            UserDefaults.standard.removeObject(forKey: "userID")
            
            CurrentUserInfo.shared.clearAll()
            
            delegate.window?.rootViewController = loginVC
            
        } catch {
            
            print("Error")
            
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationController?.navigationBar.barStyle = .black
        
        navigationController?.navigationBar.isHidden = true
        
        imagePickerController.allowsEditing = true
        
        imagePickerController.delegate = self
        
        setupUserImage()
                
        getUserInfo()
        
    }
    
    func getUserInfo() {
        
        guard let uid = UserDefaults.standard.value(forKey: "userID") as? String else {
            return
        }
        
        PBProgressHUD.pbActivityView(viewController: tabBarController!)
        
        CurrentUserInfo.shared.getLoginUserInfo(uid: uid) { [weak self] (result) in
            
            guard let strongSelf = self else {
                return
            }
            
            switch result {
                
            case .success:
                
                print("Success")
                
                strongSelf.userImage.loadImage(CurrentUserInfo.shared.userImageUrl, placeHolder: UIImage(named: "Icons_128px_General"))
                
                strongSelf.userName.text = CurrentUserInfo.shared.userName
                
                strongSelf.userEmail.text = CurrentUserInfo.shared.userEmail
            case .failure(let error):
                
                print(error)
            }
            
        }
    }
    
    func setupUserImage() {
        
        titleBackgroundView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        titleBackgroundView.layer.cornerRadius = titleBackgroundView.frame.width / 2
        
        userImage.layer.cornerRadius = userImage.frame.width / 2
        
        userImage.layer.borderWidth = 2
        
        userImage.layer.borderColor = UIColor.white.cgColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        
        userImage.addGestureRecognizer(tapGesture)
               
        userImage.isUserInteractionEnabled = true
        
        userImage.contentMode = .scaleAspectFill
    }
    
    @objc func presentPicker() {
        
        let imagePickerAlertController = UIAlertController(title: "上傳圖片", message: "請選擇要上傳的圖片", preferredStyle: .actionSheet)
        
        let imageFromLibAction = UIAlertAction(title: "照片圖庫", style: .default) { (_) in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                self.imagePickerController.sourceType = .photoLibrary
                
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
        }
        
        let imageFromCameraAction = UIAlertAction(title: "相機", style: .default) { (_) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                self.imagePickerController.sourceType = .camera
                
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
            
            imagePickerAlertController.dismiss(animated: true, completion: nil)
        }
        
        imagePickerAlertController.addAction(imageFromLibAction)
        
        imagePickerAlertController.addAction(imageFromCameraAction)
        
        imagePickerAlertController.addAction(cancelAction)
        
        present(imagePickerAlertController, animated: true, completion: nil)
        
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
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            
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
            
            user.reauthenticate(with: credential, completion: { (_, error) in
                
                if let error = error {
                    
                    PBProgressHUD.showFailure(text: "Old Password Wrong", viewController: self)
                    
                    print(error)
                    
                } else {
                    
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

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
                
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
             
            userImage.image = pickedImage
            
            PBProgressHUD.pbActivityView(viewController: tabBarController!)
            
            UserManager.shared.uploadImage(image: pickedImage, completion: { (result) in
                
                switch result {
                    
                case .success:
                    
                    print("upload Image Success")
                    
                case .failure(let error):
                    
                    print(error)
                    
                }
                
            })
            
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
