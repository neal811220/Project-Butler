//
//  KingFisherWapper.swift
//  Project Butler
//
//  Created by Neal on 2020/2/4.
//  Copyright © 2020 neal812220. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {
    
    func loadImage(_ urlString: String?, placeHolder: UIImage? = nil) {
        
        guard urlString != nil else { return }
        if urlString == "Icons_128px_Visitors" {
            self.image = UIImage(named: urlString!)
        } else {
            
            let url = URL(string: urlString!)
            
            self.kf.setImage(with: url, placeholder: placeHolder)
        }
        
    }
}
