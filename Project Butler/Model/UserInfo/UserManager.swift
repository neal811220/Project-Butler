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
import Kingfisher

typealias FetchUserResult = (Result<[AuthInfo], Error>) -> Void

typealias FetchFriendResult = (Result<[FriendDetail], Error>) -> Void

enum UserLoginError: Error {
    
    case noData
}

class UserManager {
    
    static let shared = UserManager()
    
    private init(){ }
    
    var scopeButtons = ["Friend", "Confirm", "Search User"]
    
    let db = Firestore.firestore()
    
    let storage = Storage.storage()
    
    var searchUserArray = [AuthInfo]()
    
    var friendArray = [FriendDetail]()
    
    var confirmArray = [FriendDetail]()
    
    var acceptArray = [FriendDetail]()
    
    var isSearch = false
    
    var isSearchingAll = false
    
    var imageUrl = ""
    
    var imageFrame = "?width=400&height=400"
    
    let group = DispatchGroup()
    
    let addUserGroup = DispatchGroup()
    
    var allUser: [AuthInfo] = []
    
    func notification() {
        
        NotificationCenter.default.post(name: Notification.Name("searchReload"), object: nil, userInfo: nil)
    }
    
    // MARK: - Create Data
    
    func addSocialUserData() {
        
        guard let userName = Auth.auth().currentUser?.displayName,
            let userEmail = Auth.auth().currentUser?.email,
            let uid = Auth.auth().currentUser?.uid
            else { return }
        
        addUserImage()
        
        addUserGroup.notify(queue: DispatchQueue.main) { [weak self] in
            
            guard let strongSelf = self else {
                return
            }
            
            let userdetail: [String: Any] = ["userName": userName, "userEmail": userEmail, "userImageUrl": strongSelf.imageUrl, "userID": uid]
            
            strongSelf.db.collection("users").document(uid).setData(userdetail)
            
            CurrentUserInfo.shared.userName = userName
                   
            CurrentUserInfo.shared.userEmail = userEmail
                   
            CurrentUserInfo.shared.userID = uid
                   
            CurrentUserInfo.shared.userImageUrl = strongSelf.imageUrl
        }
        
    }
    
    func addGeneralUserData(name: String, email: String, imageUrl: UIImage, uid: String) {
        
        uploadImage(image: imageUrl) {[weak self] (result) in
            
            guard let strongSelf = self else {
                
                return
            }
            switch result {
                
            case .success:
                
                let userdetail: [String: Any] = ["userName": name, "userEmail": email, "userImageUrl": strongSelf.imageUrl, "userID": uid]
                
                strongSelf.db.collection("users").document(uid).setData(userdetail)
                
                CurrentUserInfo.shared.userName = name
                
                CurrentUserInfo.shared.userEmail = email
                
                CurrentUserInfo.shared.userID = uid
                
                CurrentUserInfo.shared.userImageUrl = strongSelf.imageUrl
                
            case.failure(let error):
                
                print(error)
            }
        }
        
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
    
    func addUserImage() {
        
        addUserGroup.enter()
        
        guard let userImage = Auth.auth().currentUser?.photoURL?.absoluteString,
            
            let uid = Auth.auth().currentUser?.uid else {
                return
        }
        
        HTTPClient.shared.request(url: userImage + imageFrame) { (result) in
            
            switch result {
                
            case .success(let data):
                
                let image = UIImage(data: data)!
                
                guard let imageData = image.jpegData(compressionQuality: 1.0) else {
                    return
                }
                
                let imageReference = Storage.storage().reference().child("userImages").child("\(uid).jpg")
                
                imageReference.putData(imageData, metadata: nil) { [ weak self] (metadata, error) in
                    
                    guard let strongSelf = self else {
                        return
                    }
                    
                    if let error = error {
                        
                        print(error)
                    }
                    
                    imageReference.downloadURL { (url, error) in
                        
                        guard let url = url, error == nil else {
                            
                            strongSelf.addUserGroup.leave()
                            
                            return
                        }
                        
                        let urlString = url.absoluteString
                        
                        strongSelf.imageUrl = urlString
                        
                        strongSelf.addUserGroup.leave()
                    }
                }
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    func uploadImage(image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let uid = UserDefaults.standard.value(forKey: "userID") else {
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        let imageReference = Storage.storage().reference().child("userImages").child("\(uid).jpg")
        
        imageReference.putData(imageData, metadata: nil) { [ weak self] (metadata, error) in
            
            guard let strongSelf = self else {
                return
            }
            
            if let error = error {
                
                completion(.failure(error))
                print(error)
            }
            
            let cache = ImageCache.default
            
            cache.clearMemoryCache()
            cache.clearDiskCache { print("Done") }
            imageReference.downloadURL { (url, error) in
                
                guard let url = url, error == nil else {
                                        
                    return
                }
                
                let urlString = url.absoluteString
                
                strongSelf.imageUrl = urlString
                
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Read Data
    
    func fetchAllUser(completion: @escaping (Result<[AuthInfo], Error>) -> Void) {
        
        db.collection("users").getDocuments { [weak self] (snapshot, error) in
            
            guard let snapshot = snapshot, error == nil else {
                return
            }
            
            guard let strongSelf = self else {
                return
            }
            
            for user in snapshot.documents {
                
                do {
                    
                    guard let data = try user.data(as: AuthInfo.self, decoder: Firestore.Decoder()) else {
                        return
                    }
                    
                    strongSelf.allUser.append(data)
                    
                } catch {
                    
                    completion(.failure(error))
                    
                }
            }
            
            completion(.success(strongSelf.allUser))
        }
    }
    
    func getSeletedLeader(uid: String, completion: @escaping (Result<FriendDetail, Error>) -> Void) {
        
        guard let id = CurrentUserInfo.shared.userID else { return }
        
        db.collection("users").document(id).collection("friends").document(uid).getDocument { (snapshot, error) in
            
            if let error = error {
                
                print(error)
                
            } else {
                
                do {
                    guard let data = try snapshot?.data(as: FriendDetail.self, decoder:Firestore.Decoder()) else { return }
                    
                    completion(.success(data))
                    
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func searchAll(completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard isSearching == false else {
            return
        }
        
        isSearching = true
        
        guard let userID = CurrentUserInfo.shared.userID else { return }
        
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
                
                self.isSearching = false
                
            } else {
                
                if let error = error {
                    completion(.failure(error))
                }
                
                self.isSearching = false
                
                completion(.success(()))
                
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
        
        guard lastSearchText != text else {
            
            self.notification()
            
            return
        }
        
        lastSearchText = text
        
        guard let lastCharacter = text.last else {
            
            notification()
            
            return
        }
        
        guard isSearch == false else {
            return
        }
        
        isSearch = true
        
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
    
    // MARK: - Read Data
    
    func acceptFrined(uid: String) {
        
        guard let id = CurrentUserInfo.shared.userID else { return }
        
        db.collection("users").document(id).collection("friends").document(uid).setData(["confirm": true], merge: true)
        
        db.collection("users").document(uid).collection("friends").document(id).setData(["accept": true], merge: true)
    }
    
    func changeFriendStatus(uid: String) {
        
        guard let id = Auth.auth().currentUser?.uid else { return }
        
        var name = ""
        
        var email = ""
        
        var image = ""
        
        db.collection("users").document(id).getDocument { (snapshot, error) in
            
            guard let snapshot = snapshot, error == nil else { return }
            
            do {
                guard let data = try snapshot.data(as: AuthInfo.self, decoder: Firestore.Decoder()) else { return }
                
                name = data.userName
                
                email = data.userEmail
                
                image = data.userImageUrl
                
                let friendStatu:[String: Any] = ["accept": true, "confirm": false, "userID": id, "userName": name, "userEmail": email, "userImageUrl": image]
                self.db.collection("users").document(uid).collection("friends").document(id).setData(friendStatu)
                
            } catch {
                
                print(error)
                
            }
        }
    }
    
    // MARK: - Delete Data
    
    func refuseFriend(uid: String) {
        
        guard let id = CurrentUserInfo.shared.userID else { return }
        
        db.collection("users").document(id).collection("friends").document(uid).delete()
        
        db.collection("users").document(uid).collection("friends").document(id).delete()
        
    }
    
}
