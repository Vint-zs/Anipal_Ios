//
//  animal3.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/06.
//

import UIKit

struct AnimalPost {
    let animal: String
    let animalURLs: [String: String]
    let isUsed: Bool
    let delayTime: String
    let comingAnimal: [String: String]
    let animalImg: UIImage
    
    init(animal: String, animalURLs: [String: String], isUsed: Bool, delayTime: String, comingAnimal: [String: String], animalImg: UIImage) {
        self.animal = animal
        self.animalURLs = animalURLs
        self.isUsed = isUsed
        self.delayTime = delayTime
        self.comingAnimal = comingAnimal
        self.animalImg = animalImg
    }
}

struct Animal {
    let name: String
    let img: UIImage
    
    init(nameInit: String, image: UIImage) {
        self.name = nameInit
        self.img = image
    }
}

let animals: [Animal] = [
    Animal(nameInit: "bird", image: #imageLiteral(resourceName: "bird")),
    Animal(nameInit: "monkey2", image: #imageLiteral(resourceName: "monkey2")),
    Animal(nameInit: "panda", image: #imageLiteral(resourceName: "panda")),
    Animal(nameInit: "elephant", image: #imageLiteral(resourceName: "elephant")),
    Animal(nameInit: "dog", image: #imageLiteral(resourceName: "dog")),
    Animal(nameInit: "horse", image: #imageLiteral(resourceName: "donkey")),
    Animal(nameInit: "lion", image: #imageLiteral(resourceName: "lion")),
    Animal(nameInit: "chicken", image: #imageLiteral(resourceName: "chicken")),
    Animal(nameInit: "fox", image: #imageLiteral(resourceName: "fox")),
    Animal(nameInit: "penguin", image: #imageLiteral(resourceName: "penguin")),
    Animal(nameInit: "black", image: #imageLiteral(resourceName: "black")),
    Animal(nameInit: "monkey", image: #imageLiteral(resourceName: "monkey")),
    Animal(nameInit: "zebra", image: #imageLiteral(resourceName: "zebra")),
    Animal(nameInit: "pig", image: #imageLiteral(resourceName: "pig")),
    Animal(nameInit: "pyobeom", image: #imageLiteral(resourceName: "pyobeom")),
    Animal(nameInit: "tiger", image: #imageLiteral(resourceName: "tiger"))
]
