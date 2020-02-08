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
        
        // Do any additional setup after loading the view.
    }
    
}
