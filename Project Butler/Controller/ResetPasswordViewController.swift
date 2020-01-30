//
//  ResetPasswordViewController.swift
//  
//
//  Created by Neal on 2020/1/24.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var resetPasswordEmail: UITextField!
    
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetButton.layer.cornerRadius = 28
        
        resetPasswordEmail.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressedreset(_ sender: UIButton) {
        
        if resetPasswordEmail.text == "" {
            
            PBProgressHUD.showFailure(text: "Please enter an email", viewController: self)
            
        } else {
            
            Auth.auth().sendPasswordReset(withEmail: resetPasswordEmail.text!) { (error) in
                
                if error != nil {
                    PBProgressHUD.showFailure(text: "\(error?.localizedDescription ?? "Error")", viewController: self)
                } else {
                    
                    PBProgressHUD.showSuccess(text: "Send successfully, please reset your password by email", viewController: self)
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            
        }
    }
    
    @IBAction func skip(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
       
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           
           self.view.endEditing(true)
       }
    
}
