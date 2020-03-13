//
//  HTTPClient.swift
//  Project Butler
//
//  Created by Neal on 2020/3/1.
//  Copyright © 2020 neal812220. All rights reserved.
//

import Foundation
import UIKit

class HTTPClient {
    
    static let shared = HTTPClient()
    
    private init() {}
    
    func request(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: url) else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { (url, _, error) in
            
            if let error = error {
                
                completion(.failure(error))
                
            }
            
            guard let url = url else {
                
                return
            }
            
            completion(.success(url))
            
        }
        
        task.resume()
    }
}
