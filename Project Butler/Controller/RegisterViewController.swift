//
//  RegisterViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/1/24.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var signupEmail: UITextField!
    @IBOutlet weak var signupPassword: UITextField!
    @IBOutlet weak var signupConfirmPassword: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupButton.layer.cornerRadius = 28
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressedSignup(_ sender: UIButton) {
    }
    @IBAction func skip(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
