//
//  Accessory.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/05/15.
//

import Foundation
import UIKit

struct Accessory {
    var accessoryId: String
    var imgUrl: String
    var isOwn: Bool
    var img: UIImage
}

struct AccessoryDetail {
    var name: String
    var price: Int
    var imgUrl: String
    var img: UIImage
    var mission: [String: String]
    var category: String
    
    init(name: String, price: Int, imgUrl: String, img: UIImage, mission: [String: String], category: String) {
        self.name = name
        self.price = price
        self.imgUrl = imgUrl
        self.img = img
        self.mission = mission
        self.category = category
    }
}
