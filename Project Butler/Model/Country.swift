//
//  Country.swift
//  SearchController
//
//  Created by Zac Workman on 29/01/2019.
//  Copyright © 2019 Kwip Limited. All rights reserved.
//

import Foundation


struct Country {
    let continent: String
    let title: String
    
    static func GetAllCountries() -> [Country] {
        return [
            Country(continent:"AllFrined", title:"Denmark"),
            Country(continent:"AllFrined", title:"United Kingdom"),
            Country(continent:"AllFrined", title:"Germany"),
            Country(continent:"AllFrined", title:"France"),
            Country(continent:"AllFrined", title:"Belgium"),
            
            Country(continent:"Confirm", title:"Nepal"),
            Country(continent:"Confirm", title:"North Korea"),
            Country(continent:"Confirm", title:"Japan"),
            
            Country(continent:"Accept", title:"Algeria"),
            Country(continent:"Accept", title:"Angola"),
            Country(continent:"Accept", title:"Chad"),
            Country(continent:"Accept", title:"Sudan")
        ]
    }
}
