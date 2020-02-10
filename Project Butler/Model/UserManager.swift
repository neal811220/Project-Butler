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
import FirebaseStorage

enum ScopeButton:String {
    
    case all = "All"
    
    case confirm = "Confirm"
    
    case friend = "Friend"
}

enum LargeTitle: String {
    
    case friendList = "Friend List"
    
    case memberList = "Member List"
    
    case newProject = "New Project"
    
    case personalProject = "Personal Project"
    
}

enum PlaceHolder: String {
    
    case friendPlaceHolder = "Type Email To Search Friend"
    
    case projectPlaceHolder = "Type Project Name To Search Project"
}

typealias FetchUserResult = (Result<[AuthInfo], Error>) -> Void

typealias FetchFriendResult = (Result<[FriendDetail], Error>) -> Void


class UserManager {
    
    static let shared = UserManager()
    
    private init(){ }
    
    var scopeButtons = ["All", "Confirm", "Friend"]
    
    let db = Firestore.firestore()
    
    var searchUserArray = [AuthInfo]()
    
    var friendArray = [FriendDetail]()
    
    var confirmArray = [FriendDetail]()
    
    var acceptArray = [FriendDetail]()
    
    var image = UIImage()
    
    let group = DispatchGroup()
    
    let st = Storage.storage().reference()
    
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
    
    func getLoginUserInfo() {
       
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(uid).getDocument { (snapshot, error) in
            
            if error == nil && snapshot != nil && snapshot?.data()?.count != 0 {
                do {
                    let data = try snapshot?.data(as: AuthInfo.self, decoder: Firestore.Decoder())
                    CurrentUserInfo.shared.userName = data?.userName
                    CurrentUserInfo.shared.userEmail = data?.userEmail
                    CurrentUserInfo.shared.userID = data?.userID
                    CurrentUserInfo.shared.userImageUrl = data?.userImageUrl
                    print("Get User Info Successfully")
                } catch {
                    return
                }
            }
        }
    }
    
    func notification() {
        
        NotificationCenter.default.post(name: Notification.Name("searchReload"), object: nil, userInfo: nil)
    }
    
    func refuseFriend(uid: String) {
        
        guard let id = CurrentUserInfo.shared.userID else { return }
        
        db.collection("users").document(id).collection("friends").document(uid).delete()
        
        db.collection("users").document(uid).collection("friends").document(id).delete()
    }
    
    func acceptFrined(uid: String) {
        
        guard let id = CurrentUserInfo.shared.userID else { return }
        db.collection("users").document(id).collection("friends").document(uid).setData(["confirm": true], merge: true)
        
        db.collection("users").document(uid).collection("friends").document(id).setData(["accept": true], merge: true)
    }
    
    func changeFriendStatus(uid: String) {
        
        let current = CurrentUserInfo.shared
        guard let id = current.userID, let name = current.userName, let email = current.userEmail, let image = current.userImageUrl else { return }
        let friendStatu:[String: Any] = ["accept": true, "confirm": false, "userID": id, "userName": name, "userEmail": email, "userImageUrl": image]
        db.collection("users").document(uid).collection("friends").document(id).setData(friendStatu)
    }
    
    func addFriend(uid: String, name: String, email: String, image: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let current = Auth.auth().currentUser else { return }
        
        let currentUserId = current.uid
        
        let addStatus:[String: Any] = ["accept": false, "confirm": true, "userID": uid, "userName": name, "userEmail": email, "userImageUrl": image]
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
                self.db.collection("users").document(currentUserId).collection("friends").document(uid).setData(addStatus)
                self.changeFriendStatus(uid: uid)
                
                completion(.success(()))
                
            } else {
                
                guard let error = error else { return }
                
                completion(.failure(error))
                
                print(error)
            }
        }
    }
        
    func searchAll(completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        clearAll()
        
        lastSearchText = ""

        db.collection("users").document(userID).collection("friends").getDocuments { (snapshot, error) in
            
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
                    } catch {
                        completion(.failure(error))
                    }
                }
                
                completion(.success(()))
                
            } else {
                
                return completion(.success(()))
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
    
    var lastSearchText: String? = nil
    
    var isSearching = false
    
    func clearAll () {
        
        self.friendArray = []

        self.confirmArray = []

        self.acceptArray = []

        self.searchUserArray = []

    }
    
    func searchUser(text: String, completion: @escaping FetchUserResult) {
                
//        if isSearching {
//
//            return
//        }
//
//        isSearching = true
        
        guard lastSearchText != text else {

            self.notification()
            
            return
        }
        
        lastSearchText = text
        
        guard let lastCharacter = text.last else {
            
            notification()
            
            return
        }
        
        let nextASICCode = lastCharacter.asciiValue! + 1
        
        let nextCharacter = Character(UnicodeScalar(nextASICCode))
        
        let nextWord = text.dropLast().appending(String(nextCharacter))
        
        clearAll()
        
        db.collection("users").whereField("userEmail", isGreaterThanOrEqualTo: text).whereField("userEmail", isLessThan: nextWord).getDocuments { (snapshot, error) in
            
            if let error = error {
                print(error)
            } else {
                for document in snapshot!.documents {
                    do {
                        if let data = try document.data(as: AuthInfo.self, decoder: Firestore.Decoder()) {
                            
                            if data.userID == CurrentUserInfo.shared.userID {
                                continue
                            }
                            
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
                    
                    self.notification()
                }
            }
        }
        
    }
    
}
