//
//  JGProgressHUD.swift
//
//
//  Created by Neal on 2020/1/29.
//

import Foundation
import JGProgressHUD

enum HUDType {

    case success(String)

    case failure(String)
    
    case wait(String)
}

class PBProgressHUD {

    static let shared = PBProgressHUD()

    private init() { }

    let hud = JGProgressHUD(style: .dark)

    var view: UIView {

        return AppDelegate.shared.window!.rootViewController!.view

    }
    
    static func pbActivityView(text: String = "", viewController: UIViewController) {
        
        if !Thread.isMainThread {

            DispatchQueue.main.async {

                showSuccess(text: text, viewController: viewController)
            }
            return
        }

        shared.hud.textLabel.text = text

        shared.hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()

        shared.hud.show(in: viewController.view)

        shared.hud.dismiss(afterDelay: 1.0)
    }

    static func showSuccess(text: String = "Success", viewController: UIViewController) {

        if !Thread.isMainThread {

            DispatchQueue.main.async {

                showSuccess(text: text, viewController: viewController)
            }
            return
        }

        shared.hud.textLabel.text = text

        shared.hud.indicatorView = JGProgressHUDSuccessIndicatorView()

        shared.hud.show(in: viewController.view)

        shared.hud.dismiss(afterDelay: 1.0)
    }
    
    static func showFailure(text: String = "Failure", viewController: UIViewController) {

           if !Thread.isMainThread {

               DispatchQueue.main.async {
                showFailure(text: text, viewController: viewController)
               }

               return
           }

           shared.hud.textLabel.text = text

           shared.hud.indicatorView = JGProgressHUDErrorIndicatorView()

           shared.hud.show(in: viewController.view)

           shared.hud.dismiss(afterDelay: 1.5)
       }
}
