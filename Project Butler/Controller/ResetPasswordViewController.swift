//
//  ResetPasswordViewController.swift
//  
//
//  Created by Neal on 2020/1/24.
//

import UIKit

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var resetPasswordEmail: UITextField!
    
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetButton.layer.cornerRadius = 28
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressedreset(_ sender: UIButton) {
        
        if resetPasswordEmail.text == "" {
            
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
