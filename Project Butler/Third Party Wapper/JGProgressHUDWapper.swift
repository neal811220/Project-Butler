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
}

class PBProgressHUD {

    static let shared = PBProgressHUD()

    private init() { }

    let hud = JGProgressHUD(style: .dark)

    var view: UIView {

        return AppDelegate.shared.window!.rootViewController!.view

    }

    static func showSuccess(text: String = "Success") {

        if !Thread.isMainThread {

            DispatchQueue.main.async {

                showSuccess(text: text)
            }
            return
        }

        shared.hud.textLabel.text = text

        shared.hud.indicatorView = JGProgressHUDSuccessIndicatorView()

        shared.hud.show(in: shared.view)

        shared.hud.dismiss(afterDelay: 1.5)
    }

    static func showFailure(text: String = "Failure") {

           if !Thread.isMainThread {

               DispatchQueue.main.async {
                   showFailure(text: text)
               }

               return
           }

           shared.hud.textLabel.text = text

           shared.hud.indicatorView = JGProgressHUDErrorIndicatorView()

           shared.hud.show(in: shared.view)

           shared.hud.dismiss(afterDelay: 1.5)
       }
}

