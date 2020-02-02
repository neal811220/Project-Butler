//
//  UIImage+Extension.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/11.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

enum ImageAsset: String {
    
    //tabbarItem
    case Icons_32px_List_Normal
    
    case Icons_32px_List_Selected
    
    case Icons_32px_report_Normal
    
    case Icons_32px_report_Selected
    
    case Icons_32px_Friend_Normal
    
    case Icons_32px_Friend_Selected
    
    case Icons_32px_Profile_Normal
    
    case Icons_32px_Profile_Selected
    
    //FriendStatus
    case Icons_32px_Confirm
    
    case Icons_32px_Accept
    
    case Icons_32px_AddFriend
    
    case Icons_32px_Remove
}

extension UIImage {

    static func asset(_ asset: ImageAsset) -> UIImage? {

        return UIImage(named: asset.rawValue)
    }
}
