//
//  UserData.swift
//  Project Butler
//
//  Created by Neal on 2020/2/1.
//  Copyright © 2020 neal812220. All rights reserved.
//

import Foundation

enum ScopeButton:String {
    
    case all = "AllFriend"
    
    case confirm = "Confirm"
    
    case accept = "Accept"
}

class UserManager {
    
    static let shared = UserManager()
    
    private init(){ }
    
    var friendListLargeTitle = "Friend List"
    
    var memberListLargeTitle = "Member List"
    
    var friendSearcchPlaceHolder = "Type Email To Search Friend"
    
    var newProjectLargeTitle = "New Project"
    
    var scopeButtons = ["AllFriend", "Confirm", "Accept"]
    
    var userinfo = [FriendInfo]()
    
}

