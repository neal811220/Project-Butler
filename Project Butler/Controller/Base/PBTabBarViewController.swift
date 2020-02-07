//
//  PBTabBarViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/1/31.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

private enum Tab {

    case personal

    case report

    case friendList

    case profile

    func controller() -> UIViewController {

        var controller: UIViewController

        switch self {

        case .personal: controller = UIStoryboard.personal.instantiateInitialViewController()!

        case .report: controller = UIStoryboard.report.instantiateInitialViewController()!

        case .friendList: controller = UIStoryboard.friendList.instantiateInitialViewController()!

        case .profile: controller = UIStoryboard.profile.instantiateInitialViewController()!

        }

        controller.tabBarItem = tabBarItem()

        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)

        return controller
    }

    func tabBarItem() -> UITabBarItem {

        switch self {

        case .personal:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_32px_List_Normal),
                selectedImage: UIImage.asset(.Icons_32px_List_Selected)
            )

        case .report:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_32px_report_Normal),
                selectedImage: UIImage.asset(.Icons_32px_report_Selected)
            )

        case .friendList:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_32px_Friend_Normal),
                selectedImage: UIImage.asset(.Icons_32px_Friend_Selected)
            )

        case .profile:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_32px_Profile_Normal),
                selectedImage: UIImage.asset(.Icons_32px_Profile_Selected)
            )
        }
    }
}

class PBTabBarViewController: UITabBarController {

    private let tabs: [Tab] = [.personal, .report, .friendList, .profile]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = tabs.map({ $0.controller() })
        
    }

    // MARK: - UITabBarControllerDelegate

    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {

        guard let navVC = viewController as? UINavigationController,
              navVC.viewControllers.first is PersonalViewController
        else { return true }

        return true
    }
}
