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
}
