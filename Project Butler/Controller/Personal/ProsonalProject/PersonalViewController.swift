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
    }

    @IBAction func loginButton(_ sender: UIButton) {
        guard let loginVC = UIStoryboard.login.instantiateViewController(identifier: "LoginPage") as? LoginViewController else { return }
        present(loginVC, animated: true, completion: nil)
        
    }
    
}

