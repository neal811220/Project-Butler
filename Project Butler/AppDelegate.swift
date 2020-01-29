//
//  AppDelegate.swift
//  Project Butler
//
//  Created by Neal on 2020/1/22.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    static let shared = UIApplication.shared.delegate as! AppDelegate
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        FirebaseApp.configure()
       
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
       
        GIDSignIn.sharedInstance()?.delegate = self
        
        // Override point for customization after application launch.
        return true
    }
    
    @available(iOS 9.0, *)
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        ApplicationDelegate.shared.application(app, open: url, options: options)
        
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
    
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            print("Success!!")
            print(result)
        }
    }

    // MARK: UISceneSession Lifecycle

}

