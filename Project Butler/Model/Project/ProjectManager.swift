//
//  ProjectManager.swift
//  Project Butler
//
//  Created by Neal on 2020/2/11.
//  Copyright © 2020 neal812220. All rights reserved.
//

import Foundation
import Firebase

class ProjectManager {
    
    static let shared = ProjectManager()
    
    private init() {}
    
    let db = Firestore.firestore()
    
    var friendArray: [FriendDetail] = []
    
    var filterArray: [FriendDetail] = []
    
    var lastSearchText: String? = nil
    
    var isSearching = false
    
    func clearAll () {
        
        self.friendArray = []
        
    }
    
    func fetchFriends(completion: @escaping (Result<[FriendDetail], Error>) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        print(uid)
        db.collection("users").document(uid).collection("friends").whereField("accept", isEqualTo: true).whereField("confirm", isEqualTo: true).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot, error == nil else {
                completion(.failure(error!))
                return
            }
            
            for document in snapshot.documents {
                
                do {
                    guard let data = try document.data(as: FriendDetail.self, decoder: Firestore.Decoder()) else { return }
                    
                    self.friendArray.append(data)
                    
                } catch {
                    
                    completion(.failure(error))
                    
                }
            }
            
            completion(.success(self.friendArray))
        }
        
    }
    
    func filterSearch(text: String, completion: @escaping (Result<[FriendDetail], Error>) -> Void) {
        
        guard lastSearchText != text else {
                        
            return
        }
        
        lastSearchText = text
        
        guard let lastCharacter = text.last else {
                        
            return
        }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let nextASICCode = lastCharacter.asciiValue! + 1
        
        let nextCharacter = Character(UnicodeScalar(nextASICCode))
        
        let nextWord = text.dropLast().appending(String(nextCharacter))
        
        clearAll()
        
        db.collection("users").document(uid).collection("friends").whereField("userEmail", isGreaterThanOrEqualTo: text).whereField("userEmail", isLessThan: nextWord).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot, error == nil else {
                
                completion(.failure(error!))
                return
            }
            
            for document in snapshot.documents {
                
                do {
                    
                    guard let data = try document.data(as: FriendDetail.self, decoder: Firestore.Decoder()) else { return }
                    
                    self.filterArray.append(data)
                    
                } catch {
                    
                    completion(.failure(error))
                    
                }
            }
            
            completion(.success(self.filterArray))
            
        }
        
    }
}
