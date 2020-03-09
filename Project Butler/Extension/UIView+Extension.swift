//
//  UIView+Extension.swift
//  Project Butler
//
//  Created by Neal on 2020/3/9.
//  Copyright © 2020 neal812220. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat? = 0,
                paddingLeft: CGFloat? = 0,
                paddingBottom: CGFloat? = 0,
                paddingRight: CGFloat? = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            
            topAnchor.constraint(equalTo: top, constant: paddingTop!).isActive = true
        }
        
        if let left = left {
            
            leftAnchor.constraint(equalTo: left, constant: paddingLeft!).isActive = true
        }
        
        if let bottom = bottom {
            
            if let paddingBottom = paddingBottom {
               
                bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
            }
        }
        
        if let right = right {
           
            if let paddingRight = paddingRight {
                
                rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
            }
        }
        
        if let width = width {
            
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
