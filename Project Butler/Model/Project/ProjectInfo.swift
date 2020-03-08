//
//  ProjectInfo.swift
//  Project Butler
//
//  Created by Neal on 2020/2/13.
//  Copyright © 2020 neal812220. All rights reserved.
//

import Foundation
import Firebase

struct ProjectDetail: Codable {
    
    let projectName: String
    
    let projectLeaderID: String
    
    let color: String
    
    let startDate: String
    
    let endDate: String
    
    let projectMember: [DocumentReference]
    
    let projectMemberID: [String]
    
    let totalDays: Int
    
    let totalHours: Int
    
    let isCompleted: Bool = false
    
    let projectID: String
    
    let workItems: [String]
    
    let memberImages: [String]
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

struct WorkLogContent: Codable {
    
    let userID: String
    
    let userName: String
    
    var date: String
    
    let workItem: String
    
    let startTime: String
    
    let endTime: String
    
    let problem: String
    
    let workContent: String
    
    let hour: Int
    
    let minute: Int
}
