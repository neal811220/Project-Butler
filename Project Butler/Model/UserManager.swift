//
//  UserData.swift
//  Project Butler
//
//  Created by Neal on 2020/2/1.
//  Copyright © 2020 neal812220. All rights reserved.
//

import Foundation
import Firebase

enum ScopeButton:String {
    
    case all = "AllFriend"
    
    case confirm = "Confirm"
    
    case accept = "Accept"
}

enum LargeTitle: String {
    
    case friendList = "Friend List"
    
    case memberList = "Member List"
    
    case newProject = "New Project"
}

class UserManager {
    
    static let shared = UserManager()
    
    private init(){ }
    
    var friendSearcchPlaceHolder = "Type Email To Search Friend"
    
    var scopeButtons = ["AllFriend", "Confirm", "Accept"]
    
    let db = Firestore.firestore()
    
    var userinfo = [FriendInfo]()
    
    func addUserData(name: String, email: String, imageUrl: String) {
        
        db.collection("users").addDocument(data:[
            "UserName": name,
            "UserEmail": email,
            "UserImageUrl": imageUrl
        ])
    }
    
}

