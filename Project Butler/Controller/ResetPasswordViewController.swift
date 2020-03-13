//
//  ResetPasswordViewController.swift
//  
//
//  Created by Neal on 2020/1/24.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {
    
    var emailText = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
    
    @objc func pressedreset(_ sender: UIButton) {
        
        view.endEditing(true)
        
        if emailText == "" {
            
            PBProgressHUD.showFailure(text: "Please enter an email", viewController: self)
            
        } else {
            
            Auth.auth().sendPasswordReset(withEmail: emailText) { (error) in
                
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
    
    @objc func skip(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
       
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           
           self.view.endEditing(true)
       }
    
}

extension ResetPasswordViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResetCell", for: indexPath) as? ResetPasswordTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        cell.resetButton.addTarget(self, action: #selector(pressedreset), for: .touchUpInside)
        
        cell.skipButton.addTarget(self, action: #selector(skip), for: .touchUpInside)
        
        return cell
    }
}

extension ResetPasswordViewController: ResetPasswordTableViewCellDelegate {
    
    func passInputText(_ resetPasswordTableViewCell: ResetPasswordTableViewCell, email: String) {
        
        self.emailText = email
    }

}
