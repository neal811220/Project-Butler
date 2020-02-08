//
//  UIColor+Extension.swift
//  Project Butler
//
//  Created by Neal on 2020/2/8.
//  Copyright © 2020 neal812220. All rights reserved.
//

import Foundation
import UIKit

private enum GHColor: String {
    // swiftlint:disable identifier_name
    case G1
    
    case B1
    
    case B2
}
extension UIColor {
    
    static let G1 = GHColor(.G1)
    
    static let B1 = GHColor(.B1)
    
    static let B2 = GHColor(.B2)
    
    // swiftlint:enable identifier_name
    private static func GHColor(_ color: GHColor) -> UIColor? {
        return UIColor(named: color.rawValue)
    }
}
