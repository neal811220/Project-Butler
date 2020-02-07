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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
