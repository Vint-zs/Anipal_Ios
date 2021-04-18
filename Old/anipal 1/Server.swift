//
//  Server.swift
//  anipal 1
//
//  Created by 이예주 on 2021/04/18.
//

import Foundation
import UIKit

func get(url: String, token: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    guard let url = URL(string: url) else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: completionHandler).resume()
}
