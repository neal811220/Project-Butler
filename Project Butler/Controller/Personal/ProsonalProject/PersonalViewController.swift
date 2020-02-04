//
//  ViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/1/22.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class PersonalViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        UserManager.shared.getUserInfo { (result) in
            switch result {
                
            case .success(let data):
                
                print("GetUserInfoSuccess!===>>\(data)")
                
            case .failure(let error):
                
                print(error)
            }
        }
    }

    @IBAction func loginButton(_ sender: UIButton) {
        guard let loginVC = UIStoryboard.login.instantiateViewController(identifier: "LoginPage") as? LoginViewController else { return }
        present(loginVC, animated: true, completion: nil)
        
    }
    
}

