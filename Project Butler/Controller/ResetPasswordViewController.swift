//
//  ResetPasswordViewController.swift
//  
//
//  Created by Neal on 2020/1/24.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var resetPasswordEmail: UITextField!
    
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetButton.layer.cornerRadius = 28
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressedreset(_ sender: UIButton) {
        
    }
    
    @IBAction func skip(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
