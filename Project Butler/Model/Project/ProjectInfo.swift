//
//  ProjectInfo.swift
//  Project Butler
//
//  Created by Neal on 2020/2/13.
//  Copyright © 2020 neal812220. All rights reserved.
//

import Foundation
import Firebase

struct NewProject: Codable {
    
    let projectName: String
    
    let projectLeaderID: String
    
    let startDate: String
    
    let endDate: String
    
    let projectMember: [DocumentReference]
    
    let projectMemberID: [String]
    
    let totalDays: Int
    
    let totalHours: Int
    
    let isCompleted: Bool = false
    
    let projectID: String
    
    let category: [String]
}

struct workItem: Codable {
    
    let itemID: String = ""
    
    let itemCategory: String = ""
    
    let itemContent: String = ""
    
    let userID: String
    
    let timeSpent: Int
}

struct CompletedProject {
    
    let projectName: String
    
    let projectLeaderID: String
    
    let startDate: String
    
    let endDate: String
    
    let projectMember: [DocumentReference]
    
    let projectMemberID: [String]
    
    let totalDays: Int
    
    let totalHours: Int
    
    let isCompleted: Bool = false
    
    let projectID: String
    
    let category: [String]
    
    let completedDate: String
    
    let completedHour: String
}
