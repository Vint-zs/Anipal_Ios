//
//  animal3.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/06.
//

import UIKit

struct Animal {
    let name :String
    let img : UIImage
    
    init(n:String, i:UIImage) {
        name = n
        img = i
    }
}


let animals:[Animal] = [
    Animal(n: "bird", i: #imageLiteral(resourceName: "bird")),
    Animal(n: "monkey2", i: #imageLiteral(resourceName: "monkey2")),
    Animal(n: "panda", i: #imageLiteral(resourceName: "panda")),
    Animal(n: "elephant", i: #imageLiteral(resourceName: "elephant")),
    Animal(n: "dog", i: #imageLiteral(resourceName: "dog")),
    Animal(n: "horse", i: #imageLiteral(resourceName: "donkey")),
    Animal(n: "lion", i: #imageLiteral(resourceName: "lion")),
    Animal(n: "chicken", i: #imageLiteral(resourceName: "chicken")),
    Animal(n: "fox", i: #imageLiteral(resourceName: "fox")),
    Animal(n: "penguin", i: #imageLiteral(resourceName: "penguin")),
    Animal(n: "black", i: #imageLiteral(resourceName: "black")),
    Animal(n: "monkey", i: #imageLiteral(resourceName: "monkey")),
    Animal(n: "zebra", i: #imageLiteral(resourceName: "zebra")),
    Animal(n: "pig", i: #imageLiteral(resourceName: "pig")),
    Animal(n: "pyobeom", i: #imageLiteral(resourceName: "pyobeom")),
    Animal(n: "tiger", i: #imageLiteral(resourceName: "tiger"))
]




