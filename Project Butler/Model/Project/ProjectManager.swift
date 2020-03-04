//
//  ProjectManager.swift
//  Project Butler
//
//  Created by Neal on 2020/2/11.
//  Copyright © 2020 neal812220. All rights reserved.
//

import Foundation
import Firebase

enum FetchUserProjectError: Error {
    
    case noProject
}

class ProjectManager {
    
    static let shared = ProjectManager()
    
    private init() {}
    
    let db = Firestore.firestore()
    
    var friendArray: [FriendDetail] = []
    
    var filterArray: [FriendDetail] = []
    
    var projectDetailArray: [ProjectDetail] = []
        
    var lastSearchText: String? = nil
    
    var isSearching = false
    
    var userProject: [ProjectDetail] = []
    
    var members: [AuthInfo] = []
    
    var workItemContent: [WorkLogContent] = []
    
    var workLogContent: [WorkLogContent] = []
    
    func clearAll () {
        
        self.friendArray = []
        
    }
    
    // MARK: - Create Data
         func createNewProject(projectID: String, newProject: ProjectDetail, completion: @escaping (Result<Void, Error>) -> Void) {
             
             do {
                 
                 try db.collection("projects").document(projectID).setData(from: newProject)
                 
             } catch {
                 
                 print("Error: \(error)")
                 
                 completion(.failure(error))
             }
             
             completion(.success(()))
         }
    
    // MARK: - Upload Data
    func uploadUserWorkLog(documentID: String, workLogContent: WorkLogContent, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let uid = UserDefaults.standard.value(forKey: "userID") as? String else {
            return
        }
        
        let docID = db.collection("projects").document(uid).collection("workLogs").document().documentID
        
        do {
            
            try db.collection("projects").document(documentID).collection("workLogs").document(docID).setData(from: workLogContent)
            
            completion(.success(()))
            
        } catch {
            
            print(error)
            
            completion(.failure(error))
        }
        
    }
    
    func fetchTapProjectDetail(projectID: String, completion: @escaping (Result<[WorkLogContent], Error>) -> Void) {
        
        db.collection("projects").document(projectID).collection("workLogs").getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot, error == nil else {
                return
            }
            
            for document in snapshot.documents {
                
                do {
                    
                    guard let data = try document.data(as: WorkLogContent.self, decoder: Firestore.Decoder()) else {
                        return
                    }
                    
                    self.workLogContent.append(data)
                    
                } catch {
                    
                    completion(.failure(error))
                    
                    print(error)
                }
            }
            
            completion(.success(self.workLogContent))
        }
    }
    
    // MARK: - Read Data
    
    func fetchUserProjectWorkLog(projectID: String, completion: @escaping (Result<[WorkLogContent], Error>) -> Void) {
        
        workItemContent = []
        
        guard let uid = UserDefaults.standard.value(forKey: "userID") as? String else {
            return
        }
        db.collection("projects").document(projectID).collection("workLogs").whereField("userID", isEqualTo: uid).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot, error == nil else {
                return
            }
            
            for document in snapshot.documents {
                
                do {
                    
                    guard let data = try document.data(as: WorkLogContent.self, decoder: Firestore.Decoder()) else {
                        return
                    }
                    
                    self.workItemContent.append(data)
                    
                } catch {
                    
                    completion(.failure(error))
                    
                }
                
                completion(.success(self.workItemContent))
            }
            
        }
    }
    
    func fetchMemberDetail(projectMember: DocumentReference, completion: @escaping (Result<AuthInfo, Error>) -> Void) {
        
        projectMember.getDocument { (snapshot, error) in
            
            guard let snapshot = snapshot, error == nil else {
                
                return
            }
            
            do {
                
                guard let data = try snapshot.data(as: AuthInfo.self, decoder: Firestore.Decoder()) else {
                    
                    return
                }
                
                completion(.success(data))
                
            } catch {
                
                completion(.failure(error))
                
            }
            
        }
    }
    
    func fetchUserProjects(isCompleted: Bool, completion: @escaping (Result<[ProjectDetail], Error>) -> Void) {
        
        guard let uid = UserDefaults.standard.value(forKey: "userID") else { return }
                
        db.collection("projects").whereField("projectMemberID", arrayContains: uid).whereField("isCompleted", isEqualTo: isCompleted).getDocuments { [weak self] (snapshot, error) in
            
            guard let snapshot = snapshot, error == nil else {
                
                return
            }
            
            guard let strongSelf = self else {
                
                return
            }
            for document in snapshot.documents {
                
                do {
                    
                    guard let data = try document.data(as: ProjectDetail.self, decoder: Firestore.Decoder()) else { return }
                    
                    strongSelf.projectDetailArray.append(data)
                    
                } catch {
                    
                    completion(.failure(error))
                }
            }
            
            completion(.success(strongSelf.projectDetailArray))
            
//            completion(.failure(FetchUserProjectError.noProject))
        }
    }
    
    func fetchFriends(completion: @escaping (Result<[FriendDetail], Error>) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
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
    
    // MARK: - Update Data
    
    func updateMember(documentID: String, memberID: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        
        var memberRef: [DocumentReference] = []
        
        for member in memberID {
            
            memberRef.append(db.collection("users").document(member))
        }
        
        db.collection("projects").document(documentID).updateData(["projectMember": FieldValue.arrayUnion(memberRef)]) { (error) in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                completion(.success(()))
            }
        }
    }
    
    func updateMemberID(documentID: String, memberID: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        
        db.collection("projects").document(documentID).updateData(["projectMemberID": FieldValue.arrayUnion(memberID)]) { (error) in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Delete Data
    
    func removeMember(documentID: String, memberID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let memberRef = db.collection("users").document(memberID)
        
        db.collection("projects").document(documentID).updateData(["projectMember": FieldValue.arrayRemove([memberRef])]) { (error) in
          
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                completion(.success(()))
                
            }
        }
    }
    
    func removeMemberID(documentID: String, removeMemberID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        db.collection("projects").document(documentID).updateData(["projectMemberID": FieldValue.arrayRemove([removeMemberID])]) { (error) in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                completion(.success(()))
                
            }
        }
    }
    
}
