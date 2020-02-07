//
//  SocialUserInfo.swift
//  Project Butler
//
//  Created by Neal on 2020/2/7.
//  Copyright © 2020 neal812220. All rights reserved.
//

import Foundation

class Social {
    
    static let shared = Social()
    
    private init() { }
    
    var userName: String?
    
    var userEmail: String?
    
    var userID: String?
    
    var userImageUrl: String?
    
}
