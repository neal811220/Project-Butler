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

enum FriendStatus: String {
    
    case friend = "Friend"
    
    case confirm = "Confirm"
    
    case accept = "Accept"
    
    case notFriend = "NotFriend"
}

protocol Userable: Codable {
    
    var userName: String { get }
    
    var userEmail: String { get }
    
    var userImageUrl: String { get }
    
    var userID: String { get }
    
    func userStatus(flag: Bool) -> String
    
    func tapAddButton()
    
    func tapAcceptButton()
    
    func tapRefuseButton()
    
}

struct AuthInfo: Codable, Userable {
    
    let userName: String
    
    let userEmail: String
    
    let userImageUrl: String
    
    let userID: String
    
    func tapAcceptButton() { }
    
    func tapAddButton() {
        
        UserManager.shared.addFriend(uid: userID, name: userName, email: userEmail, image: userImageUrl) { (result) in
            
            switch result {
                
            case .success(()):
                
                guard let text = UserManager.shared.lastSearchText else { return }
                
                UserManager.shared.lastSearchText = ""
                
                UserManager.shared.searchUser(text: text) { (result) in
                    switch result {
                        
                        case .success(let data):
                            
                            print(data)
                            
                        case .failure(let error):
                            
                            print(error)
                    }
                    
                }
                
                print("AddFriend Success")
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    func tapRefuseButton() { }
    
    func userStatus(flag: Bool) -> String {
        
        return "NotFriend"
    }
    
}

struct FriendDetail: Codable, Userable {
    
    let accept: Bool
    
    let confirm: Bool
    
    let userEmail: String
    
    let userID: String
    
    let userImageUrl: String
    
    let userName: String
    
    func tapAcceptButton() {
        
        UserManager.shared.acceptFrined(uid: userID)
        
        UserManager.shared.searchAll { (result) in
            switch result {
                
            case .success(()):
                
                print("Accept Successfully")
                
            case .failure(let error):
                
                print(error)
            }
            
            UserManager.shared.notification()
        }
    }
    
    func tapRefuseButton() {
        
        UserManager.shared.refuseFriend(uid: userID)
        
        UserManager.shared.searchAll { (result) in
            switch result {
                
            case .success(()):
                
                print("Refuse Successfully")
                
            case .failure(let error):
                
                print(error)
            }
            
            UserManager.shared.notification()
        }

    }
    
    func tapAddButton() {
        
        print("...")
    }
    
    func userStatus(flag: Bool) -> String {
        
        if confirm == true && accept == true {
            return "Friend"
        } else if confirm == true && accept == false {
            return "Confirm"
        } else if confirm == false && accept == true {
            return "Accept"
        } else {
            return "NotFriend"
        }
    }
}

