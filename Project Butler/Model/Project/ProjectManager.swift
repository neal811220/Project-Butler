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
    
    var processingProjectsArray: [ProjectDetail] = []
    
    var completedProjectsArray: [ProjectDetail] = []
        
    var lastSearchText: String? = nil
    
    var isSearching = false
    
    var userProject: [ProjectDetail] = []
    
    var projectMembers: [AuthInfo] = []
        
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
    
    // MARK: - Read Data
    
    func fetchProjectWorkLog(projectID: String, completion: @escaping (Result<[WorkLogContent], Error>) -> Void) {
        
        workLogContent = []
        
        db.collection("projects").document(projectID).collection("workLogs").getDocuments { [weak self] (snapshot, error) in
            
            guard let strongSelf = self else {
                
                return
            }
            
            guard let snapshot = snapshot, error == nil else {
                
                return
            }
            
            for document in snapshot.documents {
                
                do {
                    
                    guard let data = try document.data(as: WorkLogContent.self, decoder: Firestore.Decoder()) else {
                        
                        return
                    }
                    
                    strongSelf.workLogContent.append(data)
                    
                } catch {
                    
                    completion(.failure(error))
                    
                }
            }
            
            completion(.success(strongSelf.workLogContent))
        }
    }
    
    func fetchPersonalProjectWorkLog(projectID: String, completion: @escaping (Result<[WorkLogContent], Error>) -> Void) {
        
        workLogContent = []
        
        guard let uid = UserDefaults.standard.value(forKey: "userID") as? String else {
            return
        }
        db.collection("projects").document(projectID).collection("workLogs").whereField("userID", isEqualTo: uid).getDocuments { [weak self] (snapshot, error) in
            
            guard let strongSelf = self else {
                
                return
            }
            
            guard let snapshot = snapshot, error == nil else {
                return
            }
            
            for document in snapshot.documents {
                
                do {
                    
                    guard let data = try document.data(as: WorkLogContent.self, decoder: Firestore.Decoder()) else {
                        return
                    }
                    
                    strongSelf.workLogContent.append(data)
                    
                } catch {
                    
                    completion(.failure(error))
                    
                }
                
                completion(.success(strongSelf.workLogContent))
            }
            
        }
    }
    
    func fetchMemberDetail(projectMember: [DocumentReference], completion: @escaping (Result<[AuthInfo], Error>) -> Void) {
        
        for member in projectMember {
            
            member.getDocument { [weak self] (snapshot, error) in
                
                guard let strongSelf = self else {
                    
                    return
                }
                
                guard let snapshot = snapshot, error == nil else {
                    
                    return
                }
                
                do {
                    
                    guard let data = try snapshot.data(as: AuthInfo.self, decoder: Firestore.Decoder()) else {
                        
                        return
                    }
                    
                    strongSelf.projectMembers.append(data)
                    
                    
                    if strongSelf.projectMembers.count == projectMember.count {
                        
                        completion(.success(strongSelf.projectMembers))
                        
                    }
                    
                } catch {
                    
                    completion(.failure(error))
                    
                }
            }
        }
        
        
    }
    
    func fetchUserProcessingProjects(completion: @escaping (Result<[ProjectDetail], Error>) -> Void) {
        
        guard let uid = UserDefaults.standard.value(forKey: "userID") else { return }
                
        db.collection("projects").whereField("projectMemberID", arrayContains: uid).whereField("isCompleted", isEqualTo: false).getDocuments { [weak self] (snapshot, error) in
            
            guard let snapshot = snapshot, error == nil else {
                
                return
            }
            
            guard let strongSelf = self else {
                
                return
            }
            for document in snapshot.documents {
                
                do {
                    
                    guard let data = try document.data(as: ProjectDetail.self, decoder: Firestore.Decoder()) else { return }
                    
                    strongSelf.processingProjectsArray.append(data)
                    
                } catch {
                    
                    completion(.failure(error))
                }
            }
            
            completion(.success(strongSelf.processingProjectsArray))
            
        }
    }
    
    func fetchUserCompletedProjects(completion: @escaping (Result<[ProjectDetail], Error>) -> Void) {
        
        guard let uid = UserDefaults.standard.value(forKey: "userID") else { return }
                
        db.collection("projects").whereField("projectMemberID", arrayContains: uid).whereField("isCompleted", isEqualTo: true).getDocuments { [weak self] (snapshot, error) in
            
            guard let snapshot = snapshot, error == nil else {
                
                return
            }
            
            guard let strongSelf = self else {
                
                return
            }
            for document in snapshot.documents {
                
                do {
                    
                    guard let data = try document.data(as: ProjectDetail.self, decoder: Firestore.Decoder()) else { return }
                    
                    strongSelf.completedProjectsArray.append(data)
                    
                } catch {
                    
                    completion(.failure(error))
                }
            }
            
            completion(.success(strongSelf.completedProjectsArray))
            
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
         
         db.collection("users").document(uid).collection("friends").whereField("userEmail", isGreaterThanOrEqualTo: text).whereField("userEmail", isLessThan: nextWord).getDocuments { [weak self] (snapshot, error) in
             
            guard let strongSelf = self else {
                
                return
            }
            
             guard let snapshot = snapshot, error == nil else {
                 
                 completion(.failure(error!))
                 return
             }
             
             for document in snapshot.documents {
                 
                 do {
                     
                     guard let data = try document.data(as: FriendDetail.self, decoder: Firestore.Decoder()) else { return }
                     
                     strongSelf.filterArray.append(data)
                     
                 } catch {
                     
                     completion(.failure(error))
                     
                 }
             }
             
             completion(.success(strongSelf.filterArray))
             
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
    
    func completeProject(projectID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        db.collection("projects").document(projectID).setData(["isCompleted": true], merge: true) { (error) in
            
            if let error = error {
                
                print(error)
                
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
