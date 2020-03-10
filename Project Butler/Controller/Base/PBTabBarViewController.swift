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

    case friendList

    case profile
    
    case newProject
    
    func controller() -> UIViewController {

        var controller: UIViewController

        switch self {

        case .personal: controller = UIStoryboard.personal.instantiateInitialViewController()!

        case .friendList: controller = UIStoryboard.friendList.instantiateInitialViewController()!

        case .profile: controller = UIStoryboard.profile.instantiateInitialViewController()!
            
        case .newProject: controller = UIStoryboard.newProject.instantiateInitialViewController()!
            
        }

        controller.tabBarItem = tabBarItem()

        return controller
    }

    func tabBarItem() -> UITabBarItem {

        switch self {

        case .personal:
            return UITabBarItem(
                title: "List",
                image: UIImage.asset(.Icons_32px_List_Normal),
                selectedImage: UIImage.asset(.Icons_32px_List_Selected)
            )
            
        case .newProject:
            return UITabBarItem(
                title: "Create",
                image: UIImage.asset(.Icons_32px_CreateProject_Normal),
                selectedImage: UIImage.asset(.Icons_32px_CreateProject_Selected)
            )

        case .friendList:
            return UITabBarItem(
                title: "Friend",
                image: UIImage.asset(.Icons_32px_Friend_Normal),
                selectedImage: UIImage.asset(.Icons_32px_Friend_Selected)
            )

        case .profile:
            return UITabBarItem(
                title: "Profile",
                image: UIImage.asset(.Icons_32px_Profile_Normal),
                selectedImage: UIImage.asset(.Icons_32px_Profile_Selected)
            )
        }
    }
}

class PBTabBarViewController: UITabBarController {

    private let tabs: [Tab] = [.personal, .newProject, .friendList, .profile]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = tabs.map({ $0.controller() })
        
        tabBar.unselectedItemTintColor = UIColor.darkGray
        
        tabBar.tintColor = UIColor.B2
                        
        self.tabBar.isTranslucent = false
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
