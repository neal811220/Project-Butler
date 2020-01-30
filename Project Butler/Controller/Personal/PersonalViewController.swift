//
//  ViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/1/22.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class PersonalViewController: UIViewController {

    @IBAction func LoginButton(_ sender: UIButton) {
        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        guard let loginPage = loginStoryboard.instantiateViewController(identifier: "LoginPage") as? LoginViewController else { return }
        present(loginPage, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

