//
//  UIStoryboard+Extension.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/11.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

private struct StoryboardCategory {

    static let main = "Main"

    static let personal = "Personal"

    static let friendList = "FriendList"
    
    static let profile = "Profile"
    
    static let login = "Login"
    
    static let newProject = "NewProject"
    
}

extension UIStoryboard {

    static var main: UIStoryboard { return pbStoryboard(name: StoryboardCategory.main) }

    static var personal: UIStoryboard { return pbStoryboard(name: StoryboardCategory.personal) }

    static var friendList: UIStoryboard { return pbStoryboard(name: StoryboardCategory.friendList) }
    
    static var profile: UIStoryboard { return pbStoryboard(name: StoryboardCategory.profile) }
    
    static var login: UIStoryboard { return pbStoryboard(name: StoryboardCategory.login) }
    
    static var newProject: UIStoryboard { return pbStoryboard(name: StoryboardCategory.newProject)}

    private static func pbStoryboard(name: String) -> UIStoryboard {

        return UIStoryboard(name: name, bundle: nil)
    }
}
