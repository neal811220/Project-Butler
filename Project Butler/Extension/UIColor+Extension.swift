//
//  UIColor+Extension.swift
//  Project Butler
//
//  Created by Neal on 2020/2/8.
//  Copyright © 2020 neal812220. All rights reserved.
//

import Foundation
import UIKit

private enum PBColor: String {
    // swiftlint:disable identifier_name
    case G1
    
    case B1
    
    case B2
    
    case Gray1
    
    case Gray2
    
    case Gray3
    
    case Black1
    
    case Black2
}
extension UIColor {
    
    static let G1 = PBColor(.G1)
    
    static let B1 = PBColor(.B1)
    
    static let B2 = PBColor(.B2)
    
    static let Gray1 = PBColor(.Gray1)
    
    static let Gray2 = PBColor(.Gray2)
    
    static let Gray3 = PBColor(.Gray3)
    
    static let Black1 = PBColor(.Black1)
    
    static let Black2 = PBColor(.Black2)
    
    // swiftlint:enable identifier_name
    private static func PBColor(_ color: PBColor) -> UIColor? {
        return UIColor(named: color.rawValue)
    }
}
