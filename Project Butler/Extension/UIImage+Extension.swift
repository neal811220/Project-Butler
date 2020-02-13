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
    
    case Icons_32px_AddFriend_Normal
    
    case Icons_32px_Remove
    
    case Icons_32px_AddFriend_DidTap
    
    case Icons_32px_Refuse
    
    //General
    case Icons_128px_General
    
    //NewProject
    case Icons_32px_ProjectName
    
    case Icons_32px_Leader
    
    case Icons_32px_Calendar
    
    case Icons_32px_Member
    
    case Icons_32px_WorkItem
    
    //PersonalRightButton
    case Icons_32px_SearchProjectButton
    
    case Icons_32px_AddProjectButton
    
    //MemberButton
    case Icons_64px_Check_Normal
    
    case Icos_62px_Check_Selected
    
    case Icons_32px_AddMembers
}

extension UIImage {

    static func asset(_ asset: ImageAsset) -> UIImage? {

        return UIImage(named: asset.rawValue)
    }
}
