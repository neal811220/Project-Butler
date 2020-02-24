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
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static let shared = UIApplication.shared.delegate as! AppDelegate
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        FirebaseApp.configure()
       
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        
        // Override point for customization after application launch.
        return true
    }
    
    @available(iOS 9.0, *)
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if url.scheme == "fb2907817055943167" {

            ApplicationDelegate.shared.application(app, open: url, options: options)

            return true

        } else {

            return GIDSignIn.sharedInstance().handle(url)

        }
        
        
    }
    
}

