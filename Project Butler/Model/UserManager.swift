//
//  UserData.swift
//  Project Butler
//
//  Created by Neal on 2020/2/1.
//  Copyright © 2020 neal812220. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

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

typealias FetchUserResult = (Result<[AuthInfo], Error>) -> Void

class UserManager {
    
    static let shared = UserManager()
    
    private init(){ }
    
    var friendSearcchPlaceHolder = "Type Email To Search Friend"
    
    var scopeButtons = ["AllFriend", "Confirm", "Accept"]
    
    let db = Firestore.firestore()
    
    var userInfo = [AuthInfo]()
    
    func addUserDetail() {
        
        guard let userName = Auth.auth().currentUser?.displayName,
            let userEmail = Auth.auth().currentUser?.email,
            let userImage = Auth.auth().currentUser?.photoURL?.absoluteString
            else { return }
        
        UserManager.shared.addUserData(name: userName, email: userEmail, imageUrl: userImage)
    }
    
    func addUserData(name: String, email: String, imageUrl: String) {
        
        let uid = db.collection("users").document().documentID
        
        db.collection("users").document(uid).setData([
            "userName": name,
            "userEmail": email,
            "userImageUrl": imageUrl,
            "userID": uid
        ])
    }
    
    func getUserInfo(completion: @escaping FetchUserResult) {
        
        db.collection("users").getDocuments { (snapshot, error) in
            
            if let error = error {
                print(error)
            } else {
                for document in snapshot!.documents {
                    do {
                        if let data = try document.data(as: AuthInfo.self, decoder: Firestore.Decoder()) {
                            
                            self.userInfo.append(data)
                        }
                    } catch {
                        
                        completion(.failure(error))
                    }
                }
                completion(.success(self.userInfo))
            }
        }
    }
    
}

