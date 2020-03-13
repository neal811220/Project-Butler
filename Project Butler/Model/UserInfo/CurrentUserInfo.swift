//
//  CurrentUserInfo.swift
//  Project Butler
//
//  Created by Neal on 2020/2/7.
//  Copyright © 2020 neal812220. All rights reserved.
//

import Foundation
import Firebase

class CurrentUserInfo {
    
    static let shared = CurrentUserInfo()
    
    private init() { }
    
    let userDB = Firestore.firestore()
    
    var userName: String?
    
    var userEmail: String?
    
    var userID: String?
    
    var userImageUrl: String?
        
    func clearAll() {
        
        userName = nil
        
        userEmail = nil
        
        userID = nil
        
        userImageUrl = nil
    }
    
    func getLoginUserInfo(uid: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        if userName != nil {
            
            completion(.success(()))
            
        } else {
            
            userDB.collection("users").document(uid).getDocument {[weak self] (snapshot, error) in
                
                guard let strongSelf = self else {
                    return
                }
                
                if error == nil && snapshot?.data()?.count != nil {
                    do {
                        let data = try snapshot?.data(as: AuthInfo.self, decoder: Firestore.Decoder())
                        
                        strongSelf.userName = data?.userName
                        
                        strongSelf.userEmail = data?.userEmail
                        
                        strongSelf.userID = data?.userID
                        
                        strongSelf.userImageUrl = data?.userImageUrl
                        
                        print("Get User Info Successfully")
                        
                        completion(.success(()))
                        
                    } catch {
                        
                        print(error)
                        
                        completion(.failure(error))
                    }
                }
                
            }
        }
    }
}
