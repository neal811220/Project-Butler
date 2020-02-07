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
    
    case all = "All"
    
    case confirm = "Confirm"
    
    case friend = "Friend"
}

enum LargeTitle: String {
    
    case friendList = "Friend List"
    
    case memberList = "Member List"
    
    case newProject = "New Project"
}

typealias FetchUserResult = (Result<[AuthInfo], Error>) -> Void

typealias FetchFriendResult = (Result<[FriendDetail], Error>) -> Void


class UserManager {
    
    static let shared = UserManager()
    
    private init(){ }
    
    var friendSearcchPlaceHolder = "Type Email To Search Friend"
    
    var scopeButtons = ["All", "Confirm", "Friend"]
    
    let db = Firestore.firestore()
    
    var searchUserArray = [AuthInfo]()
    
    var friendArray = [FriendDetail]()
    
    var confirmArray = [FriendDetail]()
    
    var acceptArray = [FriendDetail]()
    
    let group = DispatchGroup()
    
    
    func addSocialUserData() {
        
        guard let userName = Auth.auth().currentUser?.displayName,
            let userEmail = Auth.auth().currentUser?.email,
            let userImage = Auth.auth().currentUser?.photoURL?.absoluteString
            else { return }
        
        UserManager.shared.addGeneralUserData(name: userName, email: userEmail, imageUrl: userImage)
    }
    
    func addGeneralUserData(name: String, email: String, imageUrl: String) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userdetail: [String: Any] = ["userName": name, "userEmail": email, "userImageUrl": imageUrl, "userID": uid]
        
        db.collection("users").document(uid).setData(userdetail)
    }
    
    func addFriend(uid: String, name: String, email: String, image: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let friendStatus:[String: Any] = ["accept": false, "confirm": true, "userID": uid, "userName": name, "userEmail": email, "userImageUrl": image, "didAdd": false]
        
        db.collection("users").document(currentUserId).collection("friends").whereField("userID", isEqualTo: uid).getDocuments { (snapshot, error) in
            
            if error == nil && snapshot != nil && snapshot?.documents.count != 0 {
                
                for document in snapshot!.documents {
                    do {
                        if let data = try document.data(as: AuthInfo.self, decoder: Firestore.Decoder()) {
                            print(data)
                        }
                    } catch {
                        
                        completion(.failure(error))
                    }
                    
                    print(document.data())
                }
                
            } else if error == nil && snapshot != nil {
                self.db.collection("users").document(currentUserId).collection("friends").document(uid).setData(friendStatus)
                completion(.success(()))
                
            } else {
                
                guard let error = error else { return }
                
                completion(.failure(error))
                
                print(error)
            }
        }
    }
    
    func searchUserStatus(uid: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userID).collection("friends").whereField("userID", isEqualTo: uid).getDocuments { (snapshot, error) in
            
            
            
            if error == nil && snapshot != nil && snapshot!.documents.count != 0 {
                
                for document in snapshot!.documents {
                    do {
                        guard let data = try document.data(as: FriendDetail.self, decoder: Firestore.Decoder()) else { return }
                        
                        if data.accept == true && data.confirm == true {
                            
                            self.friendArray.append(data)
                            
                        } else if data.confirm == true && data.accept == false {
                            
                            self.confirmArray.append(data)
                            
                        } else if data.confirm == false && data.accept == true {
                            
                            self.acceptArray.append(data)
                            
                        }
                        completion(.success(()))
                        print(data)
                        
                    } catch {
                        print(error)
                        completion(.failure(error))
                    }
                }
                
            } else {
                
                self.db.collection("users").document(uid).getDocument { (snapshot, error) in
                    if error == nil {
                        do {
                            guard let data = try snapshot?.data(as: AuthInfo.self, decoder: Firestore.Decoder()) else { return }
                            
                            self.searchUserArray.append(data)
                            
                            self.group.leave()
                            
                        } catch {
                            
                            print(error)
                        }
                        
                    }
                }
            }
        }
    }
    
    var lastSearchText: String = ""
    
    func searchUser(text: String, completion: @escaping FetchUserResult) {
        
        var currentSearchUseID: String?
                
        let searchGroup = DispatchGroup()
        
        guard lastSearchText != text && currentSearchUseID  == nil else {
            
            NotificationCenter.default.post(name: Notification.Name("searchReload"), object: nil, userInfo: nil)
            
            return
        }
        
        lastSearchText = text
        
        guard let lastCharacter = text.last else {
            return
        }
        
        let nextASICCode = lastCharacter.asciiValue! + 1
        
        let nextCharacter = Character(UnicodeScalar(nextASICCode))
        
        let nextWord = text.dropLast().appending(String(nextCharacter))
        
        self.friendArray = []
        
        self.confirmArray = []
        
        self.acceptArray = []
        
        self.searchUserArray = []
        
        db.collection("users").whereField("userEmail", isGreaterThanOrEqualTo: text).whereField("userEmail", isLessThan: nextWord).getDocuments { (snapshot, error) in
            
            if let error = error {
                print(error)
            } else {
                for document in snapshot!.documents {
                    do {
                        if let data = try document.data(as: AuthInfo.self, decoder: Firestore.Decoder()) {
                            
                            currentSearchUseID = data.userID

                            self.group.enter()
                            
                            self.searchUserStatus(uid: data.userID) { (result) in
                                switch result {
                                case .success(let data):
                                    print(data)
                                case .failure(let error):
                                    print(error)
                                }
                                self.group.leave()
                            }
                        }
                    } catch {
                        
                        completion(.failure(error))
                    }
                }
                
                self.group.notify(queue: DispatchQueue.main) {
                    
                    NotificationCenter.default.post(name: Notification.Name("searchReload"), object: nil, userInfo: nil)
                }
            }
        }
        
    }
    
}

