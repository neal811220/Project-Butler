//
//  Country.swift
//  SearchController
//
//  Created by Zac Workman on 29/01/2019.
//  Copyright © 2019 Kwip Limited. All rights reserved.
//

import Foundation


struct FriendInfo {
    
    let email: String
    
    let title: String
    
    static func GetAllFriends() -> [FriendInfo] {
        return [
            FriendInfo(email:"AllFriend", title:"Denmark"),
            FriendInfo(email:"AllFriend", title:"United Kingdom"),
            FriendInfo(email:"AllFriend", title:"Germany"),
            FriendInfo(email:"AllFriend", title:"France"),
            FriendInfo(email:"AllFriend", title:"Belgium"),
            
            FriendInfo(email:"Confirm", title:"Nepal"),
            FriendInfo(email:"Confirm", title:"North Korea"),
            FriendInfo(email:"Confirm", title:"Japan"),
            
            FriendInfo(email:"Accept", title:"Algeria"),
            FriendInfo(email:"Accept", title:"Angola"),
            FriendInfo(email:"Accept", title:"Chad"),
            FriendInfo(email:"Accept", title:"Sudan")
        ]
    }
}
